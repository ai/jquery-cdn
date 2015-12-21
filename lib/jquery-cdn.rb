require 'pathname'
require 'cgi'

lib = Pathname(__FILE__).dirname.join('jquery-cdn')
require lib.join('version').to_s
require lib.join('helpers').to_s

module JqueryCdn

  version = JqueryCdn::VERSION.split('.')[0..2].join('.')
  URL = {
    google:     "//ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js",
    microsoft:  "//ajax.aspnetcdn.com/ajax/jQuery/jquery-#{version}.min.js",
    jquery:     "http://code.jquery.com/jquery-#{version}.min.js",
    yandex:     "//yandex.st/jquery/#{version}/jquery.min.js",
    cloudflare: "//cdnjs.cloudflare.com/ajax/libs/jquery/#{version}/jquery.min.js"
  }

  # Add assets paths to standalone Sprockets environment.
  def self.install(sprockets)
    root = Pathname(__FILE__).dirname.join('..').expand_path
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
    attrs = options.dup
    env   = attrs.delete(:env) || :production
    cdn   = attrs.delete(:cdn) || :google

    attrs[:src] = url(env, cdn)

    script_tag(attrs) + if not options[:defer] and env == :production
      fallback = include_jquery(options.merge(env: :development))
      escaped  = "unescape('#{ fallback.gsub('<', '%3C') }')"
      script_tag("window.jQuery || document.write(#{ escaped })")
    else
      ''
    end
  end
end

JqueryCdn.local_url = proc { '/assets/jquery.js' }
require lib.join('railties').to_s if defined? ::Rails
