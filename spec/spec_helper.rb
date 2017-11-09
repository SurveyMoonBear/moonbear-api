# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require_relative 'test_load_all'

load 'Rakefile'
Rake::Task['db:reset'].invoke

SURVEY_ID = '1ItCeIVWgVRanDJ3vaZ7gd7ByuKC69Y5U8WLI-VP0sSA'.freeze
SHEET_TITLE = 'sheet1'.freeze
CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  api_key = app.config.api_key
  c.filter_sensitive_data('<API_KEY>') { api_key }
  c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(api_key) }
end
