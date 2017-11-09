require_relative 'spec_helper.rb'

describe 'Test SurveyMoonBear Library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'codepraise_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Survey information' do
    it 'HAPPY: should provide correct survey attributes' do
      get "#{API_VER}/survey/#{SURVEY_ID}"
      _(last_response.status).must_equal 200
      survey_data = JSON.parse last_response.body
      _(survey_data.size).must_be :>, 0
    end

    it 'SAD: should raise exception on incorrect survey' do
      get "#{API_VER}/survey/bad_survey"
      _(last_response.status).must_equal 404
      body = JSON.parse last_response.body
      _(body.keys).must_include 'error'
    end
  end

  describe 'Sheet information' do
  end
end
