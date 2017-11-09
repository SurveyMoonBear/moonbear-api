require 'dry-struct'

require_relative 'item.rb'

module SurveyMoonBear
  module Entity
    # Domain entity object for git contributors
    class Page < Dry::Struct
      attribute :title, Types::Strict::String
      attribute :index, Types::Strict::Int
      attribute :items, Types::Strict::Array.member(Item)
    end
  end
end
