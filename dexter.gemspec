# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dexter/version"
require 'rake'

Gem::Specification.new do |s|
  s.name        = "dexter"
  s.version     = Dexter::VERSION
  s.authors     = ["Josep Jaume Rey"]
  s.email       = ["josepjaume@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Dexter is a handy TV Show organizer written in ruby}
  s.description = %q{Dexter is a handy TV Show organizer written in ruby}

  s.rubyforge_project = "dexter"

  s.files         = FileList['lib/**/*.rb', 'bin/*'].to_a
  s.test_files    = FileList['spec/**/*'].to_a
  s.executables   = ['dexter']
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_runtime_dependency "parslet"
end
