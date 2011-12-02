# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mollie/payment/version"

Gem::Specification.new do |s|
  s.name        = "mollie-payment"
  s.version     = Mollie::Payment::VERSION
  s.authors     = ["Gert Goet"]
  s.email       = ["gert@thinkcreate.nl"]
  s.homepage    = "https://github.com/eval/mollie-payment"
  s.summary     = %q{Client for the Mollie API (currently iDEAL only}
  s.description = %q{Client for the Mollie API (currently iDEAL only}

  s.rubyforge_project = "mollie-payment"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty"

  s.add_development_dependency "yard"
  s.add_development_dependency "rdiscount"
  s.add_development_dependency "rspec"
  s.add_development_dependency "ZenTest"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
end
