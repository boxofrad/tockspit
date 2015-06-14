module Tockspit
  TockspitError       = Class.new StandardError
  BadCredentials      = Class.new TockspitError
  RecordNotFound      = Class.new TockspitError
  BadRequest          = Class.new TockspitError
  UnprocessableEntity = Class.new TockspitError
  ClientError         = Class.new TockspitError
  ServerError         = Class.new TockspitError
end
