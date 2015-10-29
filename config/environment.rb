require 'bundler'
require 'rubygems'
Bundler.require(:default, ENV['RACK_ENV'] || 'development')

$:.unshift File.expand_path '..', __dir__
$stdout.sync = true

module OmniauthTest

  def self.env
    @env ||= (ENV['RACK_ENV'] || 'development').inquiry.freeze
  end

  def self.root
    @root ||= Pathname.new(File.expand_path '..', __dir__)
  end

  def self.logger
    @logger ||= Logger.new(root.join('log', "#{env}.log"))
  end
  def self.logger=(logger)
    @logger = logger
  end

  def self.providers=(providers)
    @_providers = providers
  end

  def self.rack_stack
    oauth_providers = @_providers
    Rack::Builder.new do
      use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']
      use OmniAuth::Builder, &oauth_providers
      run Web
    end
  end

end

autoload :Web, OmniauthTest.root.join('app', 'web.rb')

# autoload models, helpers, etc.
%w{models helpers repositories services}.each do |folder_name|
  Dir[OmniauthTest.root.join 'app', folder_name, '*.rb'].each do |file|
    klass_name = ::File.basename(file, '.rb').camelize.to_sym
    autoload klass_name, file
  end
end

# run initializers
Dir[OmniauthTest.root.join 'config', 'initializers', '**', '*.rb'].each do |filename|
  load OmniauthTest.root.join filename
end