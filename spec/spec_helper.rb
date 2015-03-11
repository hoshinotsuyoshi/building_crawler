ENV['test'] = 'true'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crawler'
require 'webmock'

PROJECT_ROOT = Pathname.new(File.expand_path('../..', __FILE__))

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
