require 'omniauth-keycloak'

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :keycloak_openid, ENV['pets-ranked-api'], ENV['5relBLBylxNAoHkwt30Ei6CtHqSvdPmE'], {  
                client_options: {
                    client_id: ENV['pets-ranked-api'],
                    client_secret: ENV['5relBLBylxNAoHkwt30Ei6CtHqSvdPmE'],
                    site: ENV['http://localhost:4000'],
                    realm: ENV['PetsRankedUserAuth'],
                    redirect_uri: 'http://localhost:3000/auth/keycloak/callback'
                } 
                
             }
  end