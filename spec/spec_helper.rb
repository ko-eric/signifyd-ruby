require 'coveralls'
Coveralls.wear!

require 'simplecov'
SimpleCov.start do
  add_group 'Signifyd', 'lib/'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../lib/signifyd', __FILE__)
require File.expand_path('../fixtures/signifyd_requests', __FILE__)
require 'faker'
require 'webmock/rspec'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

RSpec.configure do |config|
  SIGNIFYD_API_KEY = '1000000000000000010001'
    
  config.color_enabled = true
  config.tty = true
end