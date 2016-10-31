# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require "introspection/version"

Gem::Specification.new do |s|
  s.name        = "introspection"
  s.version     = Introspection::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James Mead"]
  s.email       = ["james@floehopper.org"]
  s.homepage    = "http://jamesmead.org"
  s.summary     = %q{Dynamic inspection of the hierarchy of method definitions on a Ruby object.}
  s.description = %q{}
  s.license = "MIT"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "introspection"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "metaclass", "~> 0.0.1"

  s.add_development_dependency "minitest", "~> 5.0"
  if RUBY_VERSION < '1.9.3'
    s.add_development_dependency "rake", "~> 10.0"
  else
    s.add_development_dependency "rake"
  end
  s.add_development_dependency "blankslate"
end
