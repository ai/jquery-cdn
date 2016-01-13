module JqueryCdn
  # Tell Ruby on Rails to add vendor/assets to Assets Pipeline
  class Engine < ::Rails::Engine
  end

  module RailsHelpers
    # Return <script> tags to add jQuery in Rails
    def include_jquery(options = { })
      options = { env: Rails.env.to_sym }.merge(options)
      JqueryCdn.local_url = proc { javascript_path("jquery.js") }
      JqueryCdn.include_jquery(options).html_safe
    end
  end

  class Railtie < Rails::Railtie
    initializer 'jquery-cdn' do |app|
      # Ensure that we before jquery-rails to fix name conflict
      root   = Pathname(__FILE__).dirname.join('../..').expand_path
      vendor = root.join('vendor/assets/javascripts')
      app.config.assets.prepend_path(vendor)

      # Add include_jquery helper
      ActiveSupport.on_load(:action_view) do
        include JqueryCdn::RailsHelpers
      end

      # Precompile all JS/CSS in root of app assets dirs.
      app.config.assets.precompile << 'jquery.js'
    end
  end
end
