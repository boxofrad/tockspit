module Tockspit
  class Connection
    attr_reader :subscription_id, :api_token

    def initialize(subscription_id, api_token)
      @subscription_id = subscription_id
      @api_token       = api_token
    end

    def clients
      Clients.new(request_maker)
    end

    def projects
      Projects.new(request_maker)
    end

    def self.roles(email, password)
      request_maker = RequestMaker.new(
        prefix: '/api/v2/',
        authentication: BasicAuthentication.new(email, password)
      )

      request_maker.get("roles").map { |json| Role.new(json) }
    end

    private

    def request_maker
      @request_maker ||= RequestMaker.new(
        prefix: "/#{subscription_id}/api/v2/",
        authentication: TokenAuthentication.new(api_token)
      )
    end
  end
end
