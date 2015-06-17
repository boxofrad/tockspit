module Tockspit
  class Resource
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(name, *args, &block)
      attributes.fetch(name.to_s) { super }
    end

    def created_at
      DateTime.parse attributes.fetch('created_at')
    end

    def updated_at
      DateTime.parse attributes.fetch('updated_at')
    end
  end
end
