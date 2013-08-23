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
  def self.url(env, cdn)
    if env == :production
      raise ArgumentError, "Unknown CDN #{cdn}" unless URL.has_key? cdn
      URL[cdn]
    else
      @local_url.call
    end
  end

  # Set proc to generate locale jQuery URL
  def self.local_url=(proc)
    @local_url = proc
  end

  # Return <script> tag
  def self.script_tag(attrs, body = '')
    if attrs.is_a? String
      body  = attrs
      attrs = { }
    end

    attrs = attrs.map { |key, value|
      if value == true
        " #{key}"
      else
        " #{key}=\"#{value}\""
      end
    }.join
    "<script#{ attrs }>#{ body }</script>"
  end

  # Return <script> tags with jQuery.
  def self.include_jquery(options = { })
    env = options.delete(:env) || :production
    cdn = options.delete(:cdn) || :google

    options[:src] = url(env, cdn)

    script_tag(options) + if not options[:defer] and env == :production
      fallback = include_jquery(options.merge(env: :development))
      escaped  = "unescape('#{ fallback.gsub('<', '%3C') }')"
      script_tag("window.jQuery || document.write(#{ escaped })")
    else
      ''
    end
  end
end

if defined? ::Rails
  require Pathname(__FILE__).dirname.join('jquery-cdn/railties').to_s
else
  JqueryCdn.local_url = proc { '/assets/jquery-cdn.js' }
end
