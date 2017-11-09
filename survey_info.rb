require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def gs_api_path(path)
  'https://sheets.googleapis.com/v4/spreadsheets/' + path
end

def call_gs_url(config, url)
  HTTP.get(url, params: { key: "#{config['api_key']}"})
end

gs_response = {}
gs_results = {}

survey_url = gs_api_path('1ItCeIVWgVRanDJ3vaZ7gd7ByuKC69Y5U8WLI-VP0sSA')
gs_response[survey_url] = call_gs_url(config, survey_url)

survey = gs_response[survey_url].parse
gs_results['title'] = survey['properties']['title']
gs_results['survey_url'] = survey['spreadsheetUrl']

sheets = []
survey['sheets'].each do |s|
  sheet = {}
  sheet['id'] = s['properties']['sheetId']
  sheet['title'] = s['properties']['title']
  sheet['index'] = s['properties']['index']

  survey_items_url = gs_api_path("1ItCeIVWgVRanDJ3vaZ7gd7ByuKC69Y5U8WLI-VP0sSA/values/#{s['properties']['title']}")
  gs_response["#{s['properties']['sheetId']}"] = call_gs_url(config, survey_items_url)
  sheet_value = gs_response["#{s['properties']['sheetId']}"].parse
  sheet_value['values'].shift
  sheet['values'] = sheet_value['values']
  sheets.push(sheet)
end

gs_results['pages'] = sheets

File.write('spec/fixtures/gs_response.yml', gs_response.to_yaml)
File.write('spec/fixtures/gs_results.yml', gs_results.to_yaml)
