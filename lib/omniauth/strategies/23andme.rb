require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class TwentyThreeAndMe < OmniAuth::Strategies::OAuth2
      option :name, 'twenty_three_and_me'

      option :client_options, {
        site: 'https://api.23andme.com',
        authorize_url: 'https://api.23andme.com/authorize',
        token_url: 'https://api.23andme.com/token'
      }

      option :authorize_params, grant_type: 'authorization_code'

      def request_phase
        puts authorize_params
        super
      end

      def authorize_params
        super.tap do |params|
          params[:scope] = request.params['scope'] if request.params['scope']
        end
      end

      uid { raw_info['id'].to_s }

      info do
        { id: raw_info['id'] }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/1/user').parsed
      end
    end
  end
end
