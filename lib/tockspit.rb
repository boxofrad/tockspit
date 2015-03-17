require "tockspit/version"
require "tockspit/bad_credentials"
require "tockspit/request_maker"
require "tockspit/basic_authentication"
require "tockspit/token_authentication"
require "tockspit/connection"
require "tockspit/resource"
require "tockspit/role"
require "tockspit/client"

require "net/https"
require "json"

module Tockspit
  def self.roles(email, password)
    Connection.roles(email, password)
  end
end
