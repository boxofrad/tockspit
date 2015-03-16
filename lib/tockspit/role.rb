module Tockspit
  class Role
    attr_reader :subscription_id, :company, :api_token

    def initialize(subscription_id, company, api_token)
      @subscription_id = subscription_id
      @company         = company
      @api_token       = api_token
    end

    def connection
      Connection.new(api_token)
    end
  end
end
