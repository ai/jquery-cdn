module JqueryCdn
  # Tell Ruby on Rails to add vendor/assets to Assets Pipeline
  class Engine < ::Rails::Engine
  end

  module Helpers
    def include_jquery(options = { })
      options[:env] ||= Rails.env.development?
      JqueryCdn.local_url = proc { javascript_path('jquery-cdn.js') }
      JqueryCdn.include_jquery(options).html_safe
    end
  end

  class Railtie < Rails::Railtie
    initializer 'jquery-cdn.action_view' do |app|
      ActiveSupport.on_load(:action_view) do
        include JqueryCdn::Helpers
      end
    end
  end
end
