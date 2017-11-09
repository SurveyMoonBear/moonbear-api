require 'roda'
require 'econfig'
require_relative 'lib/init.rb'

module SurveyMoonBear
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    route do |routing|
      app = Api
      config = Api.config

      # GET / request
      routing.root do
        { 'message' => "SurveyMoonBear API v0.1 up in #{app.environment}" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          # /api/v0.1/:survey_id branch
          routing.on 'survey', String do |survey_id|
            spreadsheet_api = Spreadsheet::Api.new(config.api_key)
            survey_mapper = Spreadsheet::SurveyMapper.new(spreadsheet_api)
            begin
              survey = survey_mapper.load(survey_id)
            rescue
              routing.halt(404, error: 'Survey not found')
            end

            routing.is do
              { survey: { survey_id: survey.survey_id } }
            end

            routing.get 'detail' do
              { pages: survey.pages.mapd(&:to_h) }
            end
          end
        end
      end
    end
  end
end
