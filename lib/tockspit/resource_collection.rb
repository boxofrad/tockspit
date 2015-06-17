module Tockspit
  class ResourceCollection
    attr_reader :request_maker

    def initialize(request_maker)
      @request_maker = request_maker
    end

    def all
      Enumerator.new do |y|
        page = 1

        loop do
          response = request_maker.get(endpoint, page: page)
          break if response.empty?

          response.each { |json| y << build_resource(json) }
          page  += 1
        end
      end
    end

    def find(id)
      build_resource request_maker.get(
        resource_path(id)
      )
    end

    def create(params)
      build_resource(
        request_maker.post(endpoint, params)
      )
    end

    def delete(id)
      request_maker.delete(
        resource_path(id)
      )
    end

    def update(id, params)
      build_resource request_maker.put(
        resource_path(id),
        params
      )
    end

    private

    def resource_path(id)
      [endpoint, id].join '/'
    end

    def build_resource(params)
      resource_class.new(params)
    end

    def endpoint
      @endpoint ||= resource_class_name.downcase
    end

    def resource_class
      @resource_class ||= Tockspit.const_get resource_class_name.gsub(/s$/, '')
    end

    def resource_class_name
      @resource_class_name ||= self.class.name.split('::').last
    end
  end
end
