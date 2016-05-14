class Warden::Strategies::SessionStrategy < Warden::Strategies::Base
  def valid?
    true
  end

  def authenticate!
    redirect!('/deploy_ui/login', origin: request.path)
  end
end

Warden::Strategies.add(:session, Warden::Strategies::SessionStrategy)
