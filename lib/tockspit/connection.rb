module Tockspit
  class Connection
    HEADERS = {
      "User-Agent" => "Tockspit v#{VERSION} (daniel+open-source@floppy.co)"
    }

    attr_reader :subscription_id, :api_token

    def initialize(subscription_id, api_token)
      @subscription_id = subscription_id
      @api_token       = api_token
    end

    def clients
      get("clients").map { |json| Client.new(json) }
    end

    def get(path, &block)
      response = self.class.http.request(
        Net::HTTP::Get.new(
          "/#{subscription_id}/api/v2/#{path}.json",
          HEADERS.merge("Authorization" => "Token token=#{api_token}")
        )
      )

      raise BadCredentials if response.code == '401'
      JSON.parse(response.body)
    end

    class << self
      def roles(email, password)
        get('roles') do |request|
          request.basic_auth(email, password)
        end.map { |json| Role.new(json) }
      end

      def get(path, headers = {})
        request = Net::HTTP::Get.new("/api/v2/#{path}.json", HEADERS.merge(headers))
        yield request if block_given?
        response = http.request(request)
        raise BadCredentials if response.code == '401'
        JSON.parse(response.body)
      end

      def http
        http = Net::HTTP.new('www.tickspot.com', 443)
        http.use_ssl = true
        http
      end
    end
  end
end
