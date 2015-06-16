module Tockspit
  class RequestMaker
    attr_reader :prefix, :authentication

    HEADERS = {
      "User-Agent" => "Tockspit v#{VERSION} (daniel+open-source@floppy.co)"
    }

    def initialize(opts)
      @authentication = opts.fetch(:authentication)
      @prefix         = opts.fetch(:prefix)
    end

    def get(path, params = {})
      query   = URI.encode_www_form(params)
      path    = [full_path(path), query].join '?'
      request = Net::HTTP::Get.new(path, HEADERS)
      make_request(request)
    end

    def post(path, params = {})
      request = Net::HTTP::Post.new(full_path(path), HEADERS)
      request["Content-Type"] = "application/json; charset=utf-8"
      request.body = params.to_json
      make_request(request)
    end

    def delete(path)
      request = Net::HTTP::Delete.new(full_path(path), HEADERS)
      make_request(request)
    end

    private

    def full_path(path)
      "#{prefix}#{path}.json"
    end

    def make_request(request)
      authentication.apply(request)
      response = http.request(request)
      raise_errors(response)
      JSON.parse(response.body)
    end

    def raise_errors(response)
      error = case response.code.to_i
              when 400      then BadRequest
              when 401      then BadCredentials
              when 404      then RecordNotFound
              when 406      then NotAcceptable
              when 422      then UnprocessableEntity
              when 400..499 then ClientError
              when 500..599 then ServerError
              end

      raise error, response.body if error
    end

    def http
      http = Net::HTTP.new('www.tickspot.com', 443)
      http.use_ssl = true
      http
    end
  end
end
