# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mollie/ideal/version"

Gem::Specification.new do |s|
  s.name        = "mollie-payment"
  s.version     = Mollie::Ideal::VERSION
  s.authors     = ["Gert Goet"]
  s.email       = ["gert@thinkcreate.nl"]
  s.homepage    = "https://github.com/eval/mollie-payment"
  s.summary     = %q{WIP}
  s.description = %q{WIP}

  s.rubyforge_project = "mollie-payment"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "yard"
  s.add_development_dependency "rdiscount"
  s.add_development_dependency "rspec"
  s.add_development_dependency "ZenTest"
end
