require "tockspit/version"
require "tockspit/errors"
require "tockspit/request_maker"
require "tockspit/basic_authentication"
require "tockspit/token_authentication"
require "tockspit/connection"
require "tockspit/resource"
require "tockspit/role"
require "tockspit/clients"
require "tockspit/client"

require "net/https"
require "json"

module Tockspit
  class << self
    def roles(email, password)
      Connection.roles(email, password)
    end

    alias :login :roles
  end
end
