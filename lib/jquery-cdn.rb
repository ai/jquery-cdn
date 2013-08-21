require 'pathname'

module JqueryCDN
  # Add assets paths to standalone Sprockets environment.
  def self.install(sprockets)
    sprockets.append_path(Pathname(__FILE__).dirname.join('assets/javascripts'))
  end

  if defined? ::Rails
    # Tell Ruby on Rails to add vendor/assets to Assets Pipeline
    class Engine < ::Rails::Engine
    end
  end
end
