#!/usr/bin/env rake

require 'bundler/gem_tasks'

desc 'Update assets from jQuery repo'
task :update do
  require 'json'
  require 'httpclient'

  def asset(file)
    Pathname(__FILE__).dirname.join('vendor/assets/javascripts').join(file)
  end

  def github_tags(repo)
    http = HTTPClient.new
    body = http.get("https://api.github.com/repos/#{repo}/tags").body
    response = JSON.parse(body)
    response.reject { |i| i['name'] =~ /rc|beta|alpha/ }.
             map    { |i| Gem::Version.new(i['name']) }.
             sort
  end

  def fetch(tag)
    url  = "http://ajax.googleapis.com/ajax/libs/jquery/#{tag}/jquery.js"
    path = asset("jquery.js")

    path.dirname.rmtree if path.dirname.exist?
    path.dirname.mkpath

    path.open('w') do |io|
      http = HTTPClient.new
      http.transparent_gzip_decompression = true
      io << http.get(url).body
    end
  end

  def update_version(tag)
    version_file = Pathname(__FILE__).dirname.join('lib/jquery-cdn/version.rb')
    version_file.open('w') do |io|
      io << "module JqueryCdn\n  VERSION = \"#{tag}\"\nend\n"
    end
  end

  puts "Fetching tags"
  tag = github_tags('jquery/jquery').last

  require './lib/jquery-cdn/version'
  if tag.to_s == JqueryCdn::VERSION
    puts "No releases, since #{ JqueryCdn::VERSION }"
  else
    puts "Load jQuery #{tag}"
    fetch(tag)

    puts "Update gem version"
    update_version(tag)

    puts "Done"
  end
end

desc 'Delete all generated files'
task :clobber do
  rm_r 'pkg' rescue nil
end
