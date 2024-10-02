class SessionsController < ApplicationController
before_action :authenticate_user!

  def create
    auth = request.env['omniauth.auth']

    # Extract token and user info from the auth hash
    token = auth.credentials.token
    user_info = {
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email
    }

    # Store the user info and token in the session
    session[:user_info] = user_info
    session[:token] = token

    render json: { message: 'Authenticated', user: user_info }, status: :ok
  end

  def failure
    render json: { message: 'Authentication failed' }, status: :unauthorized
  end

  def destroy
    reset_session
    render json: { message: 'Logged out' }, status: :ok
  end
end

def authenticate_user!
  token = request.headers['Authorization']&.split(' ')&.last || session[:token]
  if token && valid_token?(token)
    # User is authenticated
  else
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end

private

def valid_token?(token)
  # Optionally verify the token with Keycloak's public key
  begin
    decoded_token = JWT.decode(token, nil, true, { algorithm: 'RS256' })
    # Additional checks, like expiration or issuer
    true
  rescue JWT::DecodeError
    false
  end
end