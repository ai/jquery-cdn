require File.expand_path('../lib/jquery-cdn/version', __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'jquery-cdn'
  s.version     = JqueryCdn::VERSION
  s.summary     = 'Best way to use latest jQuery in Ruby app'

  s.files         = `git ls-files`.split("\n")
  s.require_path  = 'lib'

  s.author      = 'Andrey Sitnik'
  s.email       = 'andrey@sitnik.ru'
  s.homepage    = 'https://github.com/ai/jquery-cdn'
  s.license     = 'MIT'

  s.add_dependency 'sprockets', '>= 2'
end
