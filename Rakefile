#!/usr/bin/env rake

require "bundler/gem_tasks"

desc "Update assets from jQuery repo"
task :update do
  require "json"
  require "httpclient"

  def github_tags(repo)
    http = HTTPClient.new
    body = http.get("https://api.github.com/repos/#{repo}/tags").body
    response = JSON.parse(body)
    response.map { |i| i['name'] }.reject { |i| i =~ /rc|beta/ }.sort
  end

  def fetch(tag)
    url    = "http://ajax.googleapis.com/ajax/libs/jquery/#{tag}/jquery.js"
    assets = Pathname(__FILE__).dirname.join('vendor/assets')
    path   = assets.join('javascripts/jquery.js')

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
      io << "module JqueryCDN\n  VERSION = \"#{tag}\"\nend\n"
    end
  end

  puts "Fetching tags"
  tag = github_tags('jquery/jquery').last

  puts "Load jQuery #{tag}"
  fetch(tag)

  puts "Update gem version"
  update_version(tag)

  puts "Done"
end

desc 'Delete all generated files'
task :clobber do
  rm_r 'pkg' rescue nil
end
