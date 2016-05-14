module SessionsHelper
  def omniauth_path(type)
    "/omniauth/auth/#{type}?origin=#{CGI.escape(params.fetch(:origin, '/'))}"
  end
end
