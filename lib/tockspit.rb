require "tockspit/version"
require "tockspit/bad_credentials"
require "tockspit/role"
require "tockspit/connection"

require "net/https"
require "json"

module Tockspit
  def self.roles(email, password)
    Connection.roles(email, password)
  end
end
