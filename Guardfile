# frozen_string_literal: true
# More info at https://github.com/guard/guard#readme
directories %w(lib spec).select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") }

group :red_green_refactor, halt_on_fail: true do
  guard :rspec, all_on_start: true, failed_mode: :focus, cmd: 'bundle exec rspec' do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  end

  guard :rubocop do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
