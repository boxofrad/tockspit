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

    def get(path)
      request(Net::HTTP::Get, path)
    end

    private

    def request(klass, path)
      request = klass.new("#{prefix}#{path}.json")
      authentication.apply(request)
      response = http.request(request)
      raise_errors(response)
      JSON.parse(response.body)
    end

    def raise_errors(response)
      case response.code.to_i
      when 401
        raise BadCredentials
      end
    end

    def http
      http = Net::HTTP.new('www.tickspot.com', 443)
      http.use_ssl = true
      http
    end
  end
end
