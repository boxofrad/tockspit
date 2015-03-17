module Tockspit
  class TokenAuthentication
    attr_reader :api_token

    def initialize(api_token)
      @api_token = api_token
    end

    def apply(request)
      request["Authorization"] = "Token token=#{api_token}"
    end
  end
end
