require_relative 'spec_helper.rb'

describe 'Test Survey Library' do
  describe 'Survey information' do
    it 'HAPPY: should provide correct survey attributes' do
      survey = SurveyMoonBear::SpreadsheetAPI.new(API_KEY, cache=RESPONSE)
                                             .survey(SURVEY_ID)
      _(survey.title).must_equal CORRECT['title']
      _(survey.survey_url).must_equal CORRECT['survey_url']
    end

    describe 'Sheet information' do
      before do
        @survey = SurveyMoonBear::SpreadsheetAPI.new(API_KEY, cache=RESPONSE)
                                                .survey(SURVEY_ID)
      end

      it 'HAPPY: should identify survey pages' do
        survey_pages = @survey.survey_pages
        _(survey_pages.count).must_equal CORRECT['pages'].count
      end

      it 'HAPPY: should identify survey items in first page' do
        survey_pages = @survey.survey_pages
        survey_items = survey_pages[0].items
        _(survey_items.count).must_equal CORRECT['pages'][0]['values'].count

        names = survey_items.map(&:name)
        correct_names = CORRECT['pages'][0]['values'].map { |i| i[1] }
        _(names).must_equal correct_names
      end
    end
  end
end
