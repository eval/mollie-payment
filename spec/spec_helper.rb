require "rubygems"
require "bundler"
Bundler.setup

$:.unshift File.expand_path("../../lib", __FILE__)
require "mollie-ideal"

Bundler.require(:test)
