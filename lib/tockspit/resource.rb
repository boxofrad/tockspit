module Tockspit
  class Resource
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(name, *args, &block)
      attributes.fetch(name.to_s) { super }
    end
  end
end
