class ApplicationController < ActionController::API
  
  <<~COMMENT
  before_action :authenticate_request

  
  def authenticate_request
    
    @token = request.headers['Authorization']&.split(' ')&.last
    if @token == nil
      render json: { error: 'Token Missing' }, status: :unauthorized
    else
      @key = Rails.application.credentials.realm_public_key
      @PUBLIC_KEY = OpenSSL::PKey::RSA.new(@key)
      @ISSUER = Rails.application.credentials.realm_issuer
      @AUDIENCE = Rails.application.credentials.client_audience

      begin
        @decoded_token = JWT.decode(@token, @PUBLIC_KEY, true, {
          algorithm: 'RS256',
          iss: @ISSUER,
          aud: @AUDIENCE,
          verify_iss: true,
          verify_aud: true,
          verify_expiration: true,
        })

      rescue JWT::ExpiredSignature
        render json: { error: "Time Expired" }, status: :unauthorized
      rescue JWT::InvalidIssuerError
        render json: { error: "Invalid Issuer" }, status: :unauthorized
      rescue JWT::InvalidAudError
        render json: { error: "Invalid Audience" }, status: :unauthorized
        
      end
          
    end
  
  end

  COMMENT
  
end
