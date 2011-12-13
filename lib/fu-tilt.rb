require "fu-tilt/version"

# Makes Fu available through Tilt, also contains a utility
# function that will be added to Sinatra if Sinatra is 
# defined.
require 'fu'
require 'tilt'
require 'mustache'

module Fu
  # A subclass of Mustache that uses a callback to retrieve partials
  class Fustache < ::Mustache 

    def on_partial(&block)      
      @on_partial = block
    end

    def partial(name)
      return Fu.to_mustache(@on_partial.call(name)) if @on_partial
      "[#{name}]"
    end
  end
end

module Tilt
  class FuTemplate < Template
    self.default_mime_type = "text/html"
    def initialize_engine
      return if defined? ::Fu
      require_template_library 'fu'
    end

    def prepare; end

    def partial(name, scope)
      if scope.is_a?(Sinatra::Base)
        # Attempt to locate the template among the templates registered with Sinatra
        if template_record = scope.class.templates[name.to_sym]
          return template_record[0].call
        end
        # Look in the folder where the current partial resides or the subfolder /partials
        [ File.join(File.dirname(@file), 'partials', "#{name}.fu"),
          File.join(File.dirname(@file), "#{name}.fu") ].each do |filename|
          return File.read(filename) if File.exist?(filename)
        end
        raise "Unable to locate Fu-partial #{name}"        
      end
    end

    def evaluate(scope, locals, &block)
      fustache = ::Fu::Fustache.new
      fustache.on_partial { |name| self.partial(name, scope) }
      fustache.render(Fu.to_mustache(data), locals.merge(scope.is_a?(Hash) ? scope : {}).merge({:yield => block.nil? ? '' : block.call}))
    end
  end

  register FuTemplate, 'fu'
end

module Sinatra
  module Fu
    module Helpers
      def fu(template, options={}, locals={})
        render :fu, template, options, locals
      end
    end

    def self.registered(app)
      app.helpers(Sinatra::Fu::Helpers)
    end
  end
end
