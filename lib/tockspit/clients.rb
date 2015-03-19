require "forwardable"

module Tockspit
  class Clients
    attr_reader :request_maker

    def initialize(request_maker)
      @request_maker = request_maker
    end

    extend Forwardable
    def_delegators :to_a, :[], :count

    def to_a
      @array ||= build_array
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
