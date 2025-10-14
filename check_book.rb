require 'net/http'
require 'uri'
require 'json'

uri                           = URI.parse(ENV['TARGET'])
request                       = Net::HTTP::Get.new(uri)
request["Accept"]             = "application/json, text/javascript, */*; q=0.01"
request["Accept-Language"]    = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7,ja;q=0.6"
request["Cache-Control"]      = "no-cache"
request["Connection"]         = "keep-alive"
request["Pragma"]             = "no-cache"
request["Referer"]            = "https://sweetgrass.jp"
request["Sec-Fetch-Dest"]     = "empty"
request["Sec-Fetch-Mode"]     = "cors"
request["Sec-Fetch-Site"]     = "same-origin"
request["User-Agent"]         = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
request["X-Requested-With"]   = "XMLHttpRequest"
request["Sec-Ch-Ua"]          = "\"Google Chrome\";v=\"141\", \"Not?A_Brand\";v=\"8\", \"Chromium\";v=\"141\""
request["Sec-Ch-Ua-Mobile"]   = "?0"
request["Sec-Ch-Ua-Platform"] = "\"macOS\""
request['Cookie']             = ENV['COOKIE']

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end


yes = JSON.parse(response.body)['akiList'].length
puts "#{Time.now.to_s} check with aki:#{yes} #{response.code}"
if yes != 0

  uri                        = URI.parse(ENV['ENDPOINT'])
  request                    = Net::HTTP::Get.new(uri)
  request["Accept"]          = "application/json, text/javascript, */*; q=0.01"
  request["Accept-Language"] = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7,ja;q=0.6"
  request["Cache-Control"]   = "no-cache"

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  puts response.code
end
