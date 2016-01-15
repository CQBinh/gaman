# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gaman/version'

Gem::Specification.new do |spec|
  spec.name          = 'gaman'
  spec.version       = Gaman::VERSION
  spec.authors       = ['CAO Quang Binh']
  spec.email         = ['binhcq@asiantech.vn']

  spec.summary       = 'Github account manager.'
  spec.description   = 'Switch ssh github'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('rainbow', '2.0')

  spec.add_development_dependency 'bundler', '~> 1.11.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'

  # comment linter directly on pull request
  spec.add_development_dependency 'saddler'
  spec.add_development_dependency 'saddler-reporter-github'
  spec.add_development_dependency 'rubocop-checkstyle_formatter'

  spec.add_dependency 'thor'
end
