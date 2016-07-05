# frozen_string_literal: true

module Api

  ###
  # Api under test, default doorkeeper scope is 'account'
  ##
  class MountedSwaggerApiUnderTest < Grape::API
    desc 'Protected method with public', authorizations: { oauth2: [{ scope: 'public', description: 'anything' }] }
    get '/protected' do
      { hello: 'world' }
    end

    desc 'Protected method with private', authorizations: { oauth2: [{ scope: 'private', description: 'anything' }] }
    get '/protected_with_private_scope' do
      { hello: 'scoped world' }
    end

    desc 'Unprotected method'
    get '/unprotected' do
      { hello: 'unprotected world' }
    end

    desc 'Protected method with public that returns the user name', authorizations: { oauth2: [{ scope: 'public', description: 'anything' }] }
    get '/protected_user' do
      { hello: resource_owner.name }
    end

    desc 'This method uses Doorkeepers default scopes', authorizations: { oauth2: [] }
    get '/protected_without_scope' do
      { hello: 'protected unscoped world' }
    end

    get '/not_described_world' do
      { hello: 'non described world' }
    end

    desc 'oauth2 dsl'
    oauth2 'public'
    get '/oauth2_dsl' do
      { hello: 'oauth2_dsl' }
    end

    oauth2
    get '/oauth2_dsl_default_scopes' do
      { hello: 'oauth dsl default scopes' }
    end

    oauth2 'custom_scope'
    get '/oauth2_dsl_custom_scopes' do
      { hello: 'oauth dsl custom scopes' }
    end
  end

  class SwaggerApiUnderTest < Grape::API
    default_format :json
    format :json
    use ::WineBouncer::OAuth2
    mount MountedSwaggerApiUnderTest
  end
end
