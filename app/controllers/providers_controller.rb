require 'finch_client'

class ProvidersController < ApplicationController
    before_action :providers_list

    def index
    end

    # need to handle the 501 method not implemented cases properly

    def show
        @provider = params[:provider_id]
        client = FinchClient.new

        # todo gross
        @resp = nil
        access_token = Rails.cache.fetch("access_token/#{@provider}") do    
            @resp = client.create_sandbox(@provider)
            @resp["access_token"]
        end
        client.set_auth_token(access_token)

        @information = client.get_information
        @directory = client.get_directory
        
        # TODO handle error better
        @employee_names = {}
        @directory["individuals"].each do |individual| 
            ee_name = "#{individual['first_name']} #{individual['last_name']}"
            @employee_names[individual["id"]] = ee_name
        end
        
    end

    def individual
        @provider = params[:provider_id]
        @individual_id = params[:individual_id]

        client = FinchClient.new
        
        # todo move this code to client
        @resp = nil
        access_token = Rails.cache.fetch("access_token/#{@provider}") do    
            @resp = client.create_sandbox(@provider)
            @resp["access_token"]
        end
        client.set_auth_token(access_token)

        # TODO handle this better
        @individual = client.get_individual(@individual_id)['responses'].first['body']
        @employment = client.get_employment(@individual_id)['responses'].first['body']
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
end
