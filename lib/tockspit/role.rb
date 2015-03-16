module Tockspit
  class Role < Resource
    def connection
      Connection.new(subscription_id, api_token)
    end
  end
end
