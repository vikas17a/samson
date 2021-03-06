require_relative '../test_helper'

SingleCov.covered!

describe Stage do
  describe "#validate_deploy_groups_have_a_cluster" do
    let(:stage) { stages(:test_staging) }

    it "is valid" do
      assert_valid stage
    end

    describe "when on kubernetes" do
      before { stage.kubernetes = true }

      it "is not valid when on kubernetes but deploy groups do not know their cluster" do
        refute_valid stage
        stage.errors.full_messages.must_equal ["Kubernetes Deploy groups need to have a cluster associated, but Pod 100 did not."]
      end

      it "is not valid when on kubernetes but deploy groups do not know their cluster" do
        Kubernetes::Cluster.any_instance.stubs(connection_valid?: true, namespace_exists?: true)
        stage.deploy_groups.each do |dg|
          dg.create_cluster_deploy_group cluster: kubernetes_clusters(:test_cluster), namespace: 'staging'
        end
        assert_valid stage
      end
    end
  end
end
