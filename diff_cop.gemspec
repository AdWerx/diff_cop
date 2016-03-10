# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diff_cop/version'

Gem::Specification.new do |spec|
  spec.name          = "diff_cop"
  spec.version       = DiffCop::VERSION
  spec.authors       = ["Josh Bielick"]
  spec.email         = ["jbielick@gmail.com"]

  spec.summary       = %q{Run rubocop only against your modifications `git diff`}
  spec.description   = %q{Rubocop is great. Running rubocop on a large file of old code yields tons of violations that are risky and costly to update. This gem allows you to run rubocop only against the files and lines that you've changed/added that show up in `git diff`.}
  spec.homepage      = "http://joshbielick.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['diffcop']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "git_diff_parser"
  spec.add_dependency "rubocop"
end
