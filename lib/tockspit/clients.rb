module Tockspit
  class Clients
    attr_reader :request_maker

    def initialize(request_maker)
      @request_maker = request_maker
    end

    def all
      Enumerator.new do |y|
        page = 1

        loop do
          response = request_maker.get("clients", page: page)
          break if response.empty?

          response.each { |json| y << Client.new(json) }
          page  += 1
        end
      end
    end

    def find(id)
      Client.new request_maker.get("clients/#{id}")
    end

    def create(params)
      Client.new request_maker.post("clients", params)
    end

    def delete(id)
      request_maker.delete("clients/#{id}")
    end

    def update(id, params)
      Client.new request_maker.put("clients/#{id}", params)
    end
  end
end
