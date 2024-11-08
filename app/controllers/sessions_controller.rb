class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      user.update(api_token: SecureRandom.hex)
      render json: { api_token: user.api_token }, status: :created
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    current_user&.update(api_token: nil)
    head :no_content
  end

  private

  def current_user
    User.find_by(api_token: request.headers["Authorization"])
  end
end