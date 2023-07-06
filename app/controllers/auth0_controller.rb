# frozen_string_literal: true

class Auth0Controller < ApplicationController

  def callback
    auth_info = request.env['omniauth.auth']
    session[:credentials] = {}
    session[:credentials][:id_token] = auth_info['credentials']['id_token']
    session[:credentials][:access_token] = auth_info['credentials']['token']

    email = auth_info['info']['email']
    name = auth_info['info']['name']
    
   
    User.find_or_create_by(email: email, name: name)
    
    if User.find_by(email: email)

      session[:user_id] = email
      redirect_to root_path, notice: "Logged in successfully!"
    else
      
      redirect_to root_path, alert: "Authentication failed. User not found."
    end

    # redirect_to profile_path
  end

  def failure
    @error_msg = request.params['message']
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: AUTH0_CONFIG['auth0_client_id']
    }

    URI::HTTPS.build(host: AUTH0_CONFIG['auth0_domain'], path: '/v2/logout', query: request_params.to_query).to_s
  end
end