module JqueryCdn
  # Module to add `include_jquery` to Sinatra and other non-Rails apps.
  module Helpers
    # Return <script> tags to add jQuery
    def include_jquery(options = { })
      JqueryCdn.include_jquery(options)
    end
  end
end
