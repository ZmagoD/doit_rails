VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = "features/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
