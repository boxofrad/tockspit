require "spec_helper"
require "tockspit"

describe Tockspit do
  let(:email) { "example@email.com" }
  let(:password) { "p0nies" }

  describe ".roles" do
    def stub_roles(opts)
      stub_request(:get, "https://#{email}:#{password}@www.tickspot.com/api/v2/roles.json").to_return(opts)
    end

    example "with correct credentials" do
      stub_roles(status: 200, body: fixture("roles.json"))

      roles = Tockspit.roles(email, password)

      expect(roles.count).to eq 2
      expect(roles[0].subscription_id).to eq 15
      expect(roles[0].company).to eq "Empire"
      expect(roles[0].api_token).to eq "f67158e7bf3d7a0fcaf9d258ace8b468"
    end

    example "with incorrect credentials" do
      stub_roles(status: 401)

      expect {
        Tockspit.roles(email, password)
      }.to raise_error Tockspit::BadCredentials
    end
  end
end
