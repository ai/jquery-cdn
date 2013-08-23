require 'pathname'
require 'cgi'

require Pathname(__FILE__).dirname.join('jquery-cdn/version').to_s

module JqueryCdn
  URL = {
    google:     "//ajax.googleapis.com/ajax/libs/jquery/#{VERSION}/jquery.min.js",
    microsoft:  "//ajax.aspnetcdn.com/ajax/jQuery/jquery-#{VERSION}.min.js",
    jquery:     "http://code.jquery.com/jquery-#{VERSION}.min.js",
    yandex:     "//yandex.st/jquery/#{VERSION}/jquery.min.js",
    cloudflare: "//cdnjs.cloudflare.com/ajax/libs/jquery/#{VERSION}/jquery.min.js"
  }

  # Add assets paths to standalone Sprockets environment.
  def self.install(sprockets)
    root = Pathname(__FILE__).dirname.join('..')
    sprockets.append_path(root.join('vendor/assets/javascripts'))
  end

  # Return URL to local or CDN jQuery, depend on `env`.
  def self.url(env = nil, cdn = nil)
    env ||= :production
    cdn ||= :google

    if env == :production
      raise ArgumentError, "Unknown CDN #{cdn}" unless URL.has_key? cdn
      URL[cdn]
    else
      @local_url.call
    end
  end

  def self.local_url=(proc)
    @local_url = proc
  end

  def self.script_tag(attrs)
    '<script' + attrs.map { |k, v| " #{k}=\"#{v}\"" }.join + '></script>'
  end

  # Return <script> tag with jQuery.
  def self.include_jquery(options = { })
    env = options.delete(:env)
    cdn = options.delete(:cdn)

    options[:src] = url(env, cdn)

    script_tag(options)
  end
end

if defined? ::Rails
  require Pathname(__FILE__).dirname.join('jquery-cdn/railties').to_s
else
  JqueryCdn.local_url = proc { '/assets/jquery-cdn.js' }
end
