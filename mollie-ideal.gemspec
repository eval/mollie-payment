# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mollie/payment/version"

Gem::Specification.new do |s|
  s.name        = "mollie-payment"
  s.version     = Mollie::Payment::VERSION
  s.authors     = ["Gert Goet"]
  s.email       = ["gert@thinkcreate.nl"]
  s.homepage    = "https://github.com/eval/mollie-payment"
  s.summary     = %q{Client for the Mollie API (currently iDEAL-only)}
  s.description = %q{Client for the Mollie API (currently iDEAL-only)}

  s.rubyforge_project = "mollie-payment"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty", "~> 0.8.1"

  s.add_development_dependency "yard", "~> 0.7.4"
  s.add_development_dependency "rdiscount", "~> 1.6.8"
  s.add_development_dependency "rspec", "~> 2.7.0"
  s.add_development_dependency "ZenTest", "~> 4.6.2"
  s.add_development_dependency "vcr", "~> 1.11.3"
  s.add_development_dependency "webmock", "~> 1.7.8"
end
