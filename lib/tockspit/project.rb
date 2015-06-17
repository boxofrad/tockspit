module Tockspit
  class Project < Resource
    Client = Class.new Resource
    Tasks  = Class.new Resource

    def client
      Client.new attributes.fetch('client')
    end

    def tasks
      Tasks.new attributes.fetch('tasks')
    end
  end
end
