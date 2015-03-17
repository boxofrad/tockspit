module Tockspit
  class BasicAuthentication
    attr_reader :username, :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def apply(request)
      request.basic_auth(username, password)
    end
  end
end
