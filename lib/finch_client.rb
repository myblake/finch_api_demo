require 'json'
require 'httparty'

class FinchClient
    attr_accessor :options

    def initialize
        @base = 'https://sandbox.tryfinch.com/api'
        @options = {
            headers: {
                'Content-Type': 'application/json'
            }
        }
    end

    def create_sandbox(provider)
        HTTParty.post("#{@base}/sandbox/create", @options.merge(
                body: {
                    "provider_id": provider,
                    "products": ["company", "directory", "individual", "employment"]
                }.to_json
            )
        )
    end

    def get_directory
        HTTParty.get("#{@base}/employer/directory", @options)
    end

    def get_information
        HTTParty.get("#{@base}/employer/company", @options)
    end

    def get_individual(individual_id)
        HTTParty.post("#{@base}/employer/individual", @options.merge(
            body: {
                "requests": [
                    {
                        "individual_id": individual_id
                    }
                ]
            }.to_json
        ))
    end

    def get_employment(individual_id)
        HTTParty.post("#{@base}/employer/employment", @options.merge(
            body: {
                "requests": [
                    {
                        "individual_id": individual_id
                    }
                ]
            }.to_json
        ))
    end

    def set_auth_token(token)
        @options[:headers].merge!(Authorization: "Bearer #{token}")
    end
end
