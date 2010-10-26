require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'cucumber/rake/task'

desc "Run the specs under spec"
RSpec::Core::RakeTask.new do |t|
end

Cucumber::Rake::Task.new(:cucumber)

task :default => :spec
