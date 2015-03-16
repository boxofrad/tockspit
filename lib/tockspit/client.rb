module Tockspit
  class Client < Resource
    def updated_at
      DateTime.parse(super)
    end
  end
end
