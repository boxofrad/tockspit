require "spec_helper"
require "tockspit"

module Tockspit
  describe Role do
    describe "#connection" do
      it "returns a connection with the api token and subscription id" do
        role = Role.new("subscription_id" => 1, "api_token" => "dmiff123")
        expect(role.connection.subscription_id).to eq 1
        expect(role.connection.api_token).to eq "dmiff123"
      end
    end
  end
end
