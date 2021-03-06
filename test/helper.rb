require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack'
require 'rack/test'
require File.expand_path('../../lib/rack/google-analytics',__FILE__)

class Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app; Rack::Lint.new(@app); end
  
  def mock_app(options)
    main_app = lambda { |env|
      request = Rack::Request.new(env)
      case request.path
      when '/' then [200,{ 'Content-Type' => 'application/html' },['<head>Hello world</head>']]
      when '/admin/index' then [200,{ 'Content-Type' => 'application/html' },['<head>Hello world</head>']]
      when '/test.xml' then [200,{'Content-Type' => 'application/xml'}, ['Xml here']]
      when '/bob' then [200,{'Content-Type' => 'application/html'} ,['<body>bob here</body>']]
      else [404,'Nothing here']
      end
    }

    builder = Rack::Builder.new
    builder.use Rack::GoogleAnalytics, options
    builder.run main_app
    @app = builder.to_app
  end
end
