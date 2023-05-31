require 'finch_client'

class ProvidersController < ApplicationController
    before_action :providers_list
    before_action :set_provider_and_access_token, except: :index

    def index
    end

    def show
        @information = @client.get_information
        @directory = @client.get_directory
        
        # if directory exists build name dictionary for manager name
        build_employee_map
    end

    def individual
        @individual_id = params[:individual_id]

        # TODO handle this better

        # when restarting server and IDS invalid this object is a nicely formatted error
        # e.g. {"error_name"=>"invalid_request_error", "error_message"=>"No individual with id bc7ccc0b-f269-4baa-9627-ab80cc3249f0"}

        # can assume likely the same issue on not implemented
        # @individual['code'] == 501 and @individual['name'] == 'not_implemented_error'

        @individual = @client.get_individual(@individual_id)['responses'].first['body']
        @employment = @client.get_employment(@individual_id)['responses'].first['body']
        # debugger
    end

    private
    def providers_list
        @providers = {
            gusto: "Gusto",
            # note bamboo's key is different between sandbox and se sandbox, where it has no underscore
            bamboo_hr: "BambooHR",
            justworks: "Justworks",
            paychex_flex: "Paychex Flex",
            workday: "Workday"
        }
    end

    def set_provider_and_access_token
        @provider = params[:provider_id]
        @client = FinchClient.new

        @sandbox_create_response = nil
        access_token = Rails.cache.fetch("access_token/#{@provider}") do
            @sandbox_create_response = @client.create_sandbox(@provider)

            # handle errors here
            @sandbox_create_response["access_token"]
        end
        @client.set_auth_token(access_token)
    end

    def build_employee_map
        @employee_names = {}
        @directory["individuals"].try(:each) do |individual|
            full_name = [individual['first_name'],individual['middle_name'], individual['last_name']].join(' ')
            @employee_names[individual["id"]] = full_name
        end
    end
end
