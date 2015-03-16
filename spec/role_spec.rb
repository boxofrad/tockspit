require "spec_helper"
require "tockspit"

describe Tockspit::Role do
  describe "#connection" do
    it "returns a connection with the api token" do
      role = Tockspit::Role.new(1, 'Dunder Mifflin', 'dmiff123')
      expect(role.connection.api_token).to eq 'dmiff123'
    end
  end
end
