module Tockspit
  class Resource
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(name, *args, &block)
      attributes.fetch(name.to_s) { super }
    end

    def updated_at
      DateTime.parse attributes.fetch('updated_at')
    end
  end
end
