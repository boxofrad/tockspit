module Tockspit
  class Clients
    include Enumerable

    attr_reader :request_maker

    def initialize(request_maker)
      @request_maker = request_maker
    end

    def each(&block)
      @array ||= build_array
      @array.each(&block)
    end

    private

    def build_array
      array = []
      page  = 1

      loop do
        response = request_maker.get("clients", page: page)
        break if response.empty?

        array += response.map { |json| Client.new(json) }
        page  += 1
      end

      array
    end
  end
end
