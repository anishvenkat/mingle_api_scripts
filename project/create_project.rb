require 'net/http'
require 'net/https'
require 'time'
require 'api-auth'
require 'json'

URL = 'https://<instance name>.mingle-api.thoughtworks.com/api/v2/projects.xml'
OPTIONS = {:access_key_id => '<MINGLE USERNAME>', :access_secret_key => '<MINGLE HMAC KEY>'}
PARAMS = { :project => { :name => 'Test Project 2', :identifier => 'test_project_2' }}

def http_post(url, params, options={})
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  body = params.to_json

  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body
  request['Content-Type'] = 'application/json'
  request['Content-Length'] = body.bytesize
  
  ApiAuth.sign!(request, options[:access_key_id], options[:access_secret_key])
  
  project = http.request(request)

  if response.code.to_i > 300
    raise StandardError, <<-ERROR
    Request URL: #{url}
    Response: #{response.code}
    Response Message: #{response.message}
    Response Headers: #{response.to_hash.inspect}
    Response Body: #{response.body}
    ERROR
  end
  project
end

http_post(URL, PARAMS, OPTIONS)