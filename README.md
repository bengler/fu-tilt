Fu-tilt
=======

Tilt and Sinatra bindings for the Fu templating language.

Usage
=====

    class FuApp < Sinatra::Base
      register Sinatra::Fu
      
      get "/list" do
        fu :list, :locals => {:children => [{:name => "Arne"}, {:name => "Bjarne"}]}
      end
    end

Stick your partials in "views/partials".
