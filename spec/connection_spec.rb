require "spec_helper"
require "tockspit"

module Tockspit
  describe Connection do
    let(:email) { "example@email.com" }
    let(:password) { "p0nies" }

    describe ".roles" do
      def stub_roles(opts)
        stub_request(:get, "https://#{email}:#{password}@www.tickspot.com/api/v2/roles.json").to_return(opts)
      end

      example "with correct credentials" do
        stub_roles(body: fixture("roles.json"))

        roles = Connection.roles(email, password)

        expect(roles.count).to eq 2
        expect(roles[0].subscription_id).to eq 15
        expect(roles[0].company).to eq "Empire"
        expect(roles[0].api_token).to eq "f67158e7bf3d7a0fcaf9d258ace8b468"
      end

      example "with incorrect credentials" do
        stub_roles(status: 401)

        expect {
          Connection.roles(email, password)
        }.to raise_error BadCredentials
      end
    end

    let(:subscription_id) { 1 }
    let(:api_token) { "abc1234" }
    let(:connection) { Connection.new(subscription_id, api_token) }

    describe "#clients" do
      let(:bad_credentials_response) {
        { status: 401, body: fixture("empty.json") }
      }

      describe 'enumeration' do
        def stub_page(page)
          stub_request(:get, "https://www.tickspot.com/#{subscription_id}/api/v2/clients.json").
            with(headers: { "Authorization" => "Token token=#{api_token}" }, query: { page: page })
        end

        example "with correct credentials" do
          stub_page(1).to_return(body: fixture("clients.json"))
          stub_page(2).to_return(body: fixture("clients.json"))
          stub_page(3).to_return(body: fixture("empty.json"))

          clients = connection.clients.all

          expect(clients.count).to eq 4
          expect(clients.first.archive).to eq false
          expect(clients.first.id).to eq 12
          expect(clients.first.name).to eq "The Republic"
          expect(clients.first.updated_at).to eq DateTime.new(2014, 9, 9, 13, 36, 20)
          expect(clients.first.url).to eq "https://www.tickspot.com/api/v2/1/clients/12.json"
        end

        example "with incorrect credentials" do
          stub_page(1).to_return(bad_credentials_response)

          expect {
            connection.clients.all.first
          }.to raise_error BadCredentials
        end
      end

      describe 'find' do
        let(:client_id) { 9001 }

        def stub_find
          stub_request(:get, "https://www.tickspot.com/#{subscription_id}/api/v2/clients/#{client_id}.json").
            with(headers: { "Authorization" => "Token token=#{api_token}" })
        end

        example 'an existing record' do
          stub_find.to_return(body: fixture('client.json'))

          client = connection.clients.find(client_id)
          expect(client.id).to eq 12
          expect(client.name).to eq "The Republic"
          expect(client.updated_at).to eq DateTime.new(2014, 9, 9, 13, 36, 20)
          expect(client.url).to eq "https://www.tickspot.com/api/v2/1/clients/12.json"

          projects = client.projects
          expect(projects.count).to eq 1
          expect(projects.updated_at).to eq DateTime.new(2014, 9, 9, 13, 36, 20)
          expect(projects.url).to eq 'https://www.tickspot.com/api/v2/123/clients/12/projects.json'
        end

        example 'a non-existing record' do
          stub_find.to_return(status: 404, body: fixture('empty.json'))

          expect {
            connection.clients.find(client_id)
          }.to raise_error RecordNotFound
        end

        example 'with bad credentials' do
          stub_find.to_return(bad_credentials_response)

          expect {
            connection.clients.find(client_id)
          }.to raise_error BadCredentials
        end
      end

      describe "create" do
        def stub_create
          stub_request(:post, "https://www.tickspot.com/#{subscription_id}/api/v2/clients.json").
            with(body: "{\"name\":\"The Republic\",\"archive\":false}",
                 headers: { "Authorization" => "Token token=#{api_token}", "Content-Type" => "application/json; charset=utf-8" })
        end

        def create_client
          connection.clients.create(name: "The Republic", archive: false)
        end

        example "with valid input" do
          stub_create.to_return(status: 201, body: fixture("client.json"))
          client = create_client
          expect(client.name).to eq "The Republic"
        end

        example "with missing required parameters" do
          stub_create.to_return(status: 400, body: "Missing Required Parameters")
          expect { create_client }.to raise_error BadRequest
        end

        example "client already exists" do
          stub_create.to_return(status: 422, body: fixture("errors.json"))
          expect { create_client }.to raise_error UnprocessableEntity
        end

        example "with bad credentials" do
          stub_create.to_return(bad_credentials_response)
          expect { create_client }.to raise_error BadCredentials
        end
      end

      describe "delete" do
        let(:client_id) { 9001 }

        def stub_delete
          @delete_request = stub_request(:delete, "https://www.tickspot.com/#{subscription_id}/api/v2/clients/#{client_id}.json").
            with(headers: { "Authorization" => "Token token=#{api_token}" })
        end

        example "with valid credentials" do
          stub_delete.to_return(body: fixture("empty.json"))
          connection.clients.delete(client_id)
          expect(@delete_request).to have_been_requested
        end

        example "client has projects associated" do
          stub_delete.to_return(status: 406, body: fixture('empty.json'))

          expect {
            connection.clients.delete(client_id)
          }.to raise_error NotAcceptable
        end

        example "with bad credentials" do
          stub_delete.to_return(status: 401, body: fixture('empty.json'))

          expect {
            connection.clients.delete(client_id)
          }.to raise_error BadCredentials
        end
      end

      describe "update" do
        let(:client_id) { 9001 }

        example "with valid credentials" do
          stub_request(:put, "https://www.tickspot.com/#{subscription_id}/api/v2/clients/#{client_id}.json").
            with(body: "{\"name\":\"The Republic\"}",
                 headers: { "Authorization" => "Token token=#{api_token}", "Content-Type" => "application/json; charset=utf-8" }).
            to_return(body: fixture('client.json'))

            client = connection.clients.update(client_id, name: 'The Republic')
            expect(client.name).to eq "The Republic"
        end
      end
    end
  end
end
