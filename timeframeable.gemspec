# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timeframeable/version'

Gem::Specification.new do |gem|
  gem.name          = 'timeframeable'
  gem.version       = Timeframeable::VERSION
  gem.authors       = ['AlexanderPavlenko']
  gem.email         = ['a.pavlenko@roundlake.ru']
  gem.description   = %q{controller module for extracting datetime range from request params}
  gem.summary       = %q{datetime range extractor}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rr'
  gem.add_development_dependency 'timecop'
end
