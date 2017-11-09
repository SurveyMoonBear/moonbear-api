require 'dry-struct'

module SurveyMoonBear
  module Entity
    # Domain entity object for git contributors
    class Item < Dry::Struct
      attribute :type, Types::Strict::String
      attribute :name, Types::Strict::String
      attribute :description, Types::Strict::String
      attribute :required, Types::Strict::Int
      attribute :options, Types::Strict::String.optional
    end
  end
end
