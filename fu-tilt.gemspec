# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fu-tilt/version"

Gem::Specification.new do |s|
  s.name        = "fu-tilt"
  s.version     = Fu::Tilt::VERSION
  s.authors     = ["Simen Svale Skogsrud"]
  s.email       = ["simen@bengler.no"]
  s.homepage    = ""
  s.summary     = %q{Tilt and Sinatra support for Fu-templates}
  s.description = %q{Tilt and Sinatra support for Fu-templates}

  s.rubyforge_project = "fu-tilt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "sinatra"
  s.add_runtime_dependency "fu"
  s.add_runtime_dependency "mustache"
end
