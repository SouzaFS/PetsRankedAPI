require 'net/http'
require 'json'

class KeycloakConfiguration
  
  def initializeKeycloak()
    @username = 'admin' #Rails.application.credentials.keycloak[:username]
    @password = 'admin' #Rails.application.credentials.keycloak[:password]
    
    puts 'Initializing Keycloak Realm and Client Configuration...'

    @masterToken = getMasterToken(@username, @password)
    if @masterToken == nil
      throw new Exception('Error: Could not get master token')
    end

    if !realmExists(@masterToken)

      @realm = createRealm(@masterToken)
      if !@realm
          throw new Exception('Error: Could not create realm')
      end
    
      @client = createClient(@masterToken)
      if !@client
        throw new Exception('Error: Could not create client')
      end

      @clientId, @clientSecret = getClientId(@masterToken)
      if @clientId == nil || @clientSecret == nil
        throw new Exception('Error: Could not get client id')
      end

      @serviceAccountUserId = getServiceAccountUserId(@clientId, @masterToken)
      if @serviceAccountUserId == nil
        throw new Exception('Error: Could not get service account user id')
      end

      @managementClientId, @queryUsersRoleId, @manageUsersRoleId = getRolesIdOfRealmManagementClient(@masterToken)
      if @managementClientId == nil || @queryUsersRoleId == nil || @manageUsersRoleId == nil
        throw new Exception('Error: Could not get roles id of realm management client')
      end

      @updateClientRoles = updateClientRoles(@serviceAccountUserId, @managementClientId, @masterToken, @manageUsersRoleId, @queryUsersRoleId)
      if !@updateClientRoles
        throw new Exception('Error: Could not update client roles')
      end

      @clientScope = createClientScope(@masterToken)
      if !@clientScope
        throw new Exception('Error: Could not create client scope')
      end

      @clientScopeId = getClientScopeId(@masterToken)
      if @clientScopeId == nil
        throw new Exception('Error: Could not get client scope id')
      end

      @mapper = createMapper(@clientScopeId, @masterToken)
      if !@mapper
        throw new Exception('Error: Could not create mapper')
      end

      @updateClientScope = updateClientScope(@clientId, @clientScopeId, @masterToken)
      if !@updateClientScope
        throw new Exception('Error: Could not update client scope')
      end

    else
      puts 'Realm Already Exists...'
    end

    puts 'Keycloak Realm and Client Configuration Finished Successfully'

  end
  
  def getMasterToken(username, password)
    
    @request = Net::HTTP::Post.new('http://keycloak:9000/realms/master/protocol/openid-connect/token')
    @request.set_form_data(
      'username' => "#{username}",
      'password' => "#{password}",
      'grant_type' => 'password',
      'client_id' => 'admin-cli'
    )

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    @token = JSON.parse(@response.body)
    
    if (@response.code != '200')
      return nil
    end

    return @token['access_token']
  
  end

  def realmExists(masterToken)
    
    @request = Net::HTTP::Get.new('http://keycloak:9000/admin/realms')
    @request['Authorization'] = "Bearer #{@masterToken}"

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '200')
      return false
    end

    @realm = JSON.parse(@response.body).select { |realm| realm['realm'] == 'petsRealm' }
    if @realm.empty?
      return false
    end

    return true

  end
  
  def createRealm(masterToken)
    
    @request = Net::HTTP::Post.new('http://keycloak:9000/admin/realms')
    @request['Authorization'] = "Bearer #{@masterToken}"
    @request['Content-Type'] = 'application/json'
    @request.body = {
      'id' => 'petsRealm',
      'realm' => 'petsRealm',
      'displayName' => 'Pets Realm',
      'enabled' => true,
      'registrationAllowed' => true,
      'sslRequired' => 'external',
      'loginWithEmailAllowed' => true,
      'duplicateEmailsAllowed' => false,
      'resetPasswordAllowed' => true,
      'editUsernameAllowed' => true,
      'bruteForceProtected' => true
    }.to_json

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if(@response.code != '201')
      return false
    end

    return true
  
  end

  def createClient(masterToken)
    
    @request = Net::HTTP::Post.new('http://keycloak:9000/admin/realms/petsRealm/clients')
    @request['Authorization'] = "Bearer #{@masterToken}"
    @request['Content-Type'] = 'application/json'
    @request.body = {
      'clientId' => 'petsClient',
      'name' => 'Pets Client',
      'enabled' => true,
      'implicitFlowEnabled': true,
      'directAccessGrantsEnabled': true,
      'serviceAccountsEnabled': true,
      'webOrigins': ['https:\/\/www.keycloak.org'],
      'redirectUris' => ['https://www.keycloak.org/app/*']
    }.to_json

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if(@response.code != '201')
      return false
    end

    return true
  
  end

  def getClientId(masterToken)
    
    @request = Net::HTTP::Get.new('http://keycloak:9000/admin/realms/petsRealm/clients?clientId=petsClient')
    @request['Authorization'] = "Bearer #{@masterToken}"
    
    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '200')
      return nil
    end

    @client = JSON.parse(@response.body)
    
    return @client[0]['id'], @client[0]['secret']
  
  end

  def getServiceAccountUserId(clientId, masterToken)
    
    @request = Net::HTTP::Get.new("http://keycloak:9000/admin/realms/petsRealm/clients/#{@clientId}/service-account-user")
    @request['Authorization'] = "Bearer #{@masterToken}"

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '200')
      return nil  
    end

    @serviceAccount = JSON.parse(@response.body)

    return @serviceAccount['id']

  end

  def getRolesIdOfRealmManagementClient(masterToken)
    
    @request = Net::HTTP::Get.new('http://keycloak:9000/admin/realms/petsRealm/clients?clientId=realm-management')
    @request['Authorization'] = "Bearer #{@masterToken}"

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '200')
      return nil
    end

    @realmManagementClient = JSON.parse(@response.body)
    @realmManagementClientId = @realmManagementClient[0]['id']
    
    @request = Net::HTTP::Get.new("http://keycloak:9000/admin/realms/petsRealm/clients/#{@realmManagementClientId}/roles")
    @request['Authorization'] = "Bearer #{@masterToken}"

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '200')
      return nil
    end

    @queryUsersRole = JSON.parse(@response.body).select{ |a| a['name'] == 'query-users' }
    @manageUsersRole = JSON.parse(@response.body).select{ |a| a['name'] == 'manage-users' }

    return @realmManagementClient[0]['id'], @queryUsersRole[0]['id'], @manageUsersRole[0]['id']
  
  end

  def updateClientRoles(serviceAccountUserId, realmManagementClientId, masterToken, manageUsersRoleId, queryUsersRoleId)
    
    @request = Net::HTTP::Post.new("http://keycloak:9000/admin/realms/petsRealm/users/#{@serviceAccountUserId}/role-mappings/clients/#{@realmManagementClientId}")
    @request['Authorization'] = "Bearer #{@masterToken}"
    @request['Content-Type'] = 'application/json'

    @request.body = [{
      'id' => "#{@manageUsersRoleId}",
      'name' => 'manage-users',
    },
    {
      'id' => "#{@queryUsersRoleId}",
      'name' => 'query-users'
    }].to_json

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '204')
      return false
    end

    return true
  end

  def createClientScope(masterToken)
    
    @request = Net::HTTP::Post.new('http://keycloak:9000/admin/realms/petsRealm/client-scopes')
    @request['Authorization'] = "Bearer #{@masterToken}"
    @request['Content-Type'] = 'application/json'

    @request.body = {
      'name' => 'petsClientScope',
      'description' => 'Contains the Audience of Client for Authentication',
      'protocol' => 'openid-connect',
      'type' => 'default',
      'attributes' => {
        'display.on.consent.screen' => 'true',
        'include.in.token.scope' => 'true',
      }
    }.to_json

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '201')
      return false
    end

    return true
  
  end

  def getClientScopeId(masterToken)
    
    @request = Net::HTTP::Get.new('http://keycloak:9000/admin/realms/petsRealm/client-scopes')
    @request['Authorization'] = "Bearer #{@masterToken}"

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '200')
      return nil
    end

    @clientScope = JSON.parse(@response.body).select{ |clientScopes| clientScopes['name'] == 'petsClientScope' }

    return @clientScope[0]['id']
  
  end

  def createMapper(clientScopeId, masterToken)
    
    @request = Net::HTTP::Post.new("http://keycloak:9000/admin/realms/petsRealm/client-scopes/#{@clientScopeId}/protocol-mappers/models")
    @request['Authorization'] = "Bearer #{@masterToken}"
    @request['Content-Type'] = 'application/json'

    @request.body = {
      'name' => 'petsClientScopeMapper',
      'protocol' => 'openid-connect',
      'protocolMapper' => 'oidc-audience-mapper',
      'consentRequired' => false,
      'config' => {
        'included.client.audience' => 'petsClient',
        'id.token.claim' => 'false',
        'lightweight.claim' => 'false',
        'access.token.claim' => 'true',
        'introspection.token.claim' => 'true'
      }
    }.to_json

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '201')
      return false
    end

    return true
  
  end

  def updateClientScope(clientId, clientScopeId, masterToken)
    
    @request = Net::HTTP::Put.new("http://keycloak:9000/admin/realms/petsRealm/clients/#{@clientId}/default-client-scopes/#{@clientScopeId}")
    @request['Authorization'] = "Bearer #{@masterToken}"

    @response = Net::HTTP.start('keycloak', 9000) do |http|
      http.request(@request)
    end

    if (@response.code != '204')
      return false
    end

    return true
  
  end

end