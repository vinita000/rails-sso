class SessionsController < ApplicationController
  def index
  end

  def create
    auth = request.env['omniauth.auth']
    
    # Retrieve user information from the auth hash
    email = auth['info']['email']
    name = auth['info']['name']
    
   
    # User.find_or_create_by(email: email) do |new_user|
    
    if User.find_by(email: email)

      session[:user_id] = email
      redirect_to root_path, notice: "Logged in successfully!"
    else
      
      redirect_to root_path, alert: "Authentication failed. User not found."
    end
  end

  def failure
    # @error_msg = request.params['message']
    redirect_to root_path, alert: "Authentication failed."
  end

  def destroy
   
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end
