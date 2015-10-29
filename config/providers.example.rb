# required for omniauth-xing
# require 'multi_json'

OmniauthTest.providers = proc do
  provider :developer if OmniauthTest.env.development?
  # provider :xing, 'key', 'secret'
  # provider :github, 'key', 'secret', scope: 'user:email'
end