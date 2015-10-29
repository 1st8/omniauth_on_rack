require 'hobbit'

class Web < Hobbit::Base

  def json(data)
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
    data.to_json
  end

  get '/' do
    "Goto /auth/:provider"
  end

  get '/auth/:provider/callback' do
    json params: request.params, 'omniauth.auth' => request.env['omniauth.auth']
  end

  if OmniauthTest.env.development?
    # Used by development provider
    post '/auth/:provider/callback' do
      json params: request.params, 'omniauth.auth' => request.env['omniauth.auth']
    end
  end

end