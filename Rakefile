# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'guard/rake_task'

RSpec::Core::RakeTask.new
RuboCop::RakeTask.new
Guard::RakeTask.new

task :default => [:spec]