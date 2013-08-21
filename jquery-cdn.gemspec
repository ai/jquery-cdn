# encoding: utf-8

require './lib/jquery-cdn/version'

Gem::Specification.new do |s|
  s.name        = 'jquery-cdn'
  s.version     = JqueryCDN::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Andrey "A.I." Sitnik'
  s.email       = 'andrey@sitnik.ru'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/ai/jquery-cdn'
  s.summary     = 'Best way to use latest jQuery in Ruby app.'

  s.add_dependency 'sprockets', '>= 2'

  s.files         = `git ls-files`.split("\n")
  s.require_path  = 'lib'
end
