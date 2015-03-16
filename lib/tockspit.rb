require "tockspit/version"
require "tockspit/bad_credentials"

require "net/https"
require "json"

module Tockspit
  USER_AGENT = "Tockspit v#{VERSION} (daniel+open-source@floppy.co)"

  def self.roles(email, password)
    http = Net::HTTP.new('www.tickspot.com', 443)
    http.use_ssl = true

    request = Net::HTTP::Get.new('/api/v2/roles.json', { 'User-Agent' => USER_AGENT })
    request.basic_auth(email, password)

    response = http.request(request)

    if response.code == '401'
      raise BadCredentials
    end

    JSON.parse(response.body).map do |json|
      Role.new(json['subscription_id'], json['company'], json['api_token'])
    end
  end

  Role = Struct.new(:subscription_id, :company, :api_token)
end
