module Tockspit
  class Client < Resource
    Projects = Class.new Resource

    def projects
      Projects.new attributes.fetch('projects')
    end
  end
end
