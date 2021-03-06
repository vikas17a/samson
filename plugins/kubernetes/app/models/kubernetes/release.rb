module Kubernetes
  class Release < ActiveRecord::Base
    include Kubernetes::HasStatus

    self.table_name = 'kubernetes_releases'

    belongs_to :user
    belongs_to :build
    belongs_to :project
    has_many :release_docs, class_name: 'Kubernetes::ReleaseDoc', foreign_key: 'kubernetes_release_id'
    has_many :deploy_groups, through: :release_docs

    validates :build, :project, presence: true
    validates :status, inclusion: STATUSES
    validate :validate_docker_image_in_registry, on: :create
    validate :validate_project_ids_are_in_sync

    scope :not_dead, -> { where.not(status: :dead) }
    scope :excluding, ->(ids) { where.not(id: ids) }
    scope :with_not_dead_release_docs, -> { joins(:release_docs).where.not(Kubernetes::ReleaseDoc.table_name => { status: :dead }) }

    def release_is_live!
      finish_deploy(:live)
    end

    def fail!
      finish_deploy(:failed)
      release_docs.each { |release_doc|
        release_doc.fail! unless release_doc.live?
      }
    end

    def user
      super || NullUser.new(user_id)
    end

    def nested_error_messages
      errors.full_messages + release_docs.flat_map(&:nested_error_messages)
    end

    def docs_by_role
      @docs_by_role ||= release_docs.each_with_object({}) do |rel_doc, hash|
        hash[rel_doc.kubernetes_role.label_name] = rel_doc
      end
    end

    # Creates a new Kubernetes Release and corresponding ReleaseDocs
    def self.create_release(params)
      Kubernetes::Release.transaction do
        release = create(params.except(:deploy_groups))
        if release.persisted?
          release.send :create_release_docs, params
        end
        release
      end
    end

    def release_doc_for(deploy_group_id, role_id)
      release_docs.find_by(deploy_group_id: deploy_group_id, kubernetes_role_id: role_id)
    end

    def update_status(release_doc)
      case
      when release_docs.all?(&:live?) then self.status = :live
      when release_docs.all?(&:dead?) then self.status = :dead
      when release_doc.spinning_up? then self.status = :spinning_up
      when release_doc.spinning_down? then self.status = :spinning_down
      when release_docs.any?(&:dead?) then self.status = :spinning_down
      end
      save!
    end

    def clients
      release_docs.map(&:deploy_group).map do |deploy_group|
        query = {
          namespace: deploy_group.kubernetes_namespace,
          label_selector: {
            deploy_group_id: deploy_group.id,
            project_id: project_id,
            release_id: id
          }.to_kuber_selector
        }
        [deploy_group.kubernetes_cluster.client, query, deploy_group]
      end
    end

    private

    # Creates a ReleaseDoc per each DeployGroup and Role combination.
    def create_release_docs(params)
      params.fetch(:deploy_groups).each do |dg|
        dg.fetch(:roles).to_a.each do |role|
          release_docs.create!(
            deploy_group_id: dg.fetch(:id),
            kubernetes_role_id: role.fetch(:id),
            replica_target: role.fetch(:replicas),
            cpu: role.fetch(:cpu),
            ram: role.fetch(:ram)
          )
        end
      end
      raise 'No Kubernetes::ReleaseDoc has been created' if release_docs.empty?
    end

    def validate_docker_image_in_registry
      if build && build.docker_repo_digest.blank? && build.docker_ref.blank?
        errors.add(:build, 'Docker image was not pushed to registry')
      end
    end

    def validate_project_ids_are_in_sync
      if build && build.project_id != project_id
        errors.add(:build, 'build.project_id is out of sync with project_id')
      end
    end

    def finish_deploy(status)
      update_attributes!(status: status, deploy_finished_at: Time.now)
    end
  end
end
