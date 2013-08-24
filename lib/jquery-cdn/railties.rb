module JqueryCdn
  # Tell Ruby on Rails to add vendor/assets to Assets Pipeline
  class Engine < ::Rails::Engine
  end

  module RailsHelpers
    # Return <script> tags to add jQuery in Rails
    def include_jquery(options = { })
      options[:env] ||= Rails.env.development?
      JqueryCdn.local_url = proc { javascript_path("jquery.js") }
      JqueryCdn.include_jquery(options).html_safe
    end
  end

  class Railtie < Rails::Railtie
    initializer 'jquery-cdn.action_view' do |app|
      ActiveSupport.on_load(:action_view) do
        include JqueryCdn::RailsHelpers
      end

      # Ensure that we before jquery-rails to fix name conflict
      ActiveSupport.on_load(:after_initialize) do
        root   = Pathname(__FILE__).dirname.join('../..').expand_path
        vendor = root.join('vendor/assets/javascripts')

        Rails.application.assets.prepend_path(vendor)
      end
    end
  end
end
