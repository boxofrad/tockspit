module Tockspit
  class Connection
    HEADERS = {
      "User-Agent" => "Tockspit v#{VERSION} (daniel+open-source@floppy.co)"
    }

    attr_reader :api_token

    def initialize(api_token)
      @api_token = api_token
    end

    class << self
      def roles(email, password)
        response = get('roles.json') do |request|
          request.basic_auth(email, password)
        end

        JSON.parse(response.body).map do |json|
          Role.new(
            json['subscription_id'],
            json['company'],
            json['api_token']
          )
        end
      end

      def get(path)
        request = Net::HTTP::Get.new("/api/v2/#{path}", HEADERS)
        yield request
        response = http.request(request)
        raise BadCredentials if response.code == '401'
        response
      end

      def http
        http = Net::HTTP.new('www.tickspot.com', 443)
        http.use_ssl = true
        http
      end
    end
  end
end
