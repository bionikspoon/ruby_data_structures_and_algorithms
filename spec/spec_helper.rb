# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'rspec/its'
require 'pry'
require 'coveralls'

gem 'coveralls', require: false
SimpleCov.start
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.warnings = true
end
