require 'spec_helper'
require 'sinatra'
require 'rack/test'
require 'fu-tilt'

class FuApp < Sinatra::Base
  set :root, File.dirname(__FILE__)+"/fixtures"
  register Sinatra::Fu
  get "/list" do
    fu :list, :locals => {:children => [{:name => "Arne"}, {:name => "Bjarne"}]}
  end

  get "/master" do
    fu :master
  end
end

describe "API v1 posts" do
  include Rack::Test::Methods

  def app
    FuApp
  end

  it "'s alive" do
    get "/list"
    last_response.body.should eq "<ul><li>Arne</li><li>Bjarne</li></ul>"
  end

  it "retrieves and renders a template" do
    get "/master"
    last_response.body.should eq "<p>Hello from<span>template</span></p>"
  end

  it "gives precendence to pre-registered templates" do
    app.template(:partial) do
      "%span preregistered template"
    end
    get "/master"
    last_response.body.should eq "<p>Hello from<span>preregistered template</span></p>"
  end
end