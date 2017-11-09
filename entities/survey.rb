require 'dry-struct'

require_relative 'page.rb'

module SurveyMoonBear
  module Entity
    # Domain Entity object for any survey
    class Survey < Dry::Struct
      attribute :survey_id, Types::Strict::String
      attribute :title, Types::Strict::String
      attribute :survey_url, Types::Strict::String
      attribute :pages, Types::Strict::Array.member(Page)
    end
  end
end
