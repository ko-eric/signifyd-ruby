# -*- encoding: utf-8 -*-
require File.expand_path('../lib/signifyd/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'signifyd'
  s.version     = Signifyd::VERSION
  s.summary     = 'Ruby bindings for the Signifyd API'
  s.description = 'A ruby wrapper for the Singifyd fraud detection API.'
  s.license     = 'MIT'
  s.authors     = ['Alex Manelis']
  s.email       = ['manelis@signifyd.com']
  s.homepage    = 'https://signifyd.com/docs/api'

  s.files = Dir['Rakefile', '{bin,lib,spec}/**/*', 'README*'] & `git ls-files`.split("\n")

  s.require_paths = ['lib']
  s.rubyforge_project = 'signifyd'

  s.add_dependency 'activesupport'
  s.add_dependency 'rest-client'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rspec-mocks'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-expectations'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
end
