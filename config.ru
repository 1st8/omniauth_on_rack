require ::File.expand_path('../config/environment',  __FILE__)
require OmniauthTest.root.join('config', 'providers.rb')

use Rack::CommonLogger, Logger.new(STDOUT)
use Rack::ShowExceptions

run OmniauthTest.rack_stack