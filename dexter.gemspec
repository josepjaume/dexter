# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dexter/version"

Gem::Specification.new do |s|
  s.name        = "dexter"
  s.version     = Dexter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Josep Jaume Rey Peroy"
  s.email       = "josepjaume@gmail.com" 
  s.homepage    = "http://github.com/josepjaume/dexter"
  s.summary     = %q{Dexter helps you organize your tv series with well, you know... Dexterity}
  s.description = %q{Dexter helps you organize your tv series with well, you know... Dexterity}

  s.rubyforge_project = "dexter"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'

  s.add_runtime_dependency 'trollop'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.default_executable = 'dexter'
  s.require_paths = ["lib"]
end
