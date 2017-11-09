require_relative 'page_mapper.rb'

module SurveyMoonBear
  module Spreadsheet
    # Data Mapper object for Google Spreadsheet
    class SurveyMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(survey_id)
        survey_data = @gateway.survey_data(survey_id)
        build_entity(survey_data)
      end

      def build_entity(survey_data)
        DataMapper.new(survey_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(survey_data, gateway)
          @survey_data = survey_data
          @page_mapper = PageMapper.new(gateway)
        end

        def build_entity
          SurveyMoonBear::Entity::Survey.new(
            survey_id: survey_id,
            title: title,
            survey_url: survey_url,
            pages: pages
          )
        end

        def survey_id
          @survey_data['spreadsheetId']
        end

        def title
          @survey_data['properties']['title']
        end

        def survey_url
          @survey_data['spreadsheetUrl']
        end

        def pages
          @page_mapper.load_several(survey_id, @survey_data['sheets'])
        end
      end
    end
  end
end
