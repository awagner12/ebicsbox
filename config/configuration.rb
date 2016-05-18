# Load environment from file
require 'dotenv'
Dotenv.load

# Load BL EBICS client when in BV environment
if ENV['EBICS_CLIENT'] == 'Blebics::Client'
  require 'blebics'
end

module Epics
  module Box
    class Configuration
      def app_url
        ENV['APP_URL'] || 'http://localhost:5000'
      end

      def database_url
        test? ?
          (ENV['TEST_DATABASE_URL'] || 'jdbc:postgres://localhost/ebicsbox_test') :
          (ENV['DATABASE_URL'] || 'jdbc:postgres://localhost/ebicsbox')
      end

      def beanstalkd_url
        (ENV['BEANSTALKD_URL'] || 'localhost:11300').gsub('beanstalkd://','').gsub('/','')
      end

      def hac_retrieval_interval
        120 # seconds
      end

      def activation_check_interval
        60 * 60 # seconds
      end

      def ebics_client
        (ENV['EBICS_CLIENT'] || 'Epics::Client').constantize
      end

      def db_passphrase
        ENV['PASSPHRASE']
      end

      def test?
        ENV['ENVIRONMENT'] == 'test'
      end

      def registrations_allowed?
        ENV['ALLOW_REGISTRATIONS'] == 'enabled'
      end

      def jwt_secret
        ENV['JWT_SECRET']
      end

      def oauth_server
        ENV['OAUTH_SERVER'] || 'http://localhost:3000'
      end

      def auth_provider
        if ENV['AUTH_SERVICE'] == 'static'
          require_relative './middleware/static_authentication'
          Epics::Box::Middleware::StaticAuthentication
        else
          require_relative './middleware/oauth_authentication'
          Epics::Box::Middleware::OauthAuthentication
        end
      end
    end
  end
end
