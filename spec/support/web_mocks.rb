module WebMocks
  def stub_quiet_request
    body = {
      zip_code: '10000',
      status: 'quiet',
    }.to_json

    stub_request(:get, %r{weather-alerts\.com\/api\?zip_code=10000})
      .and_return(status: 200, body: body)
  end

  def stub_watch_request
    body = {
      zip_code: '20000',
      status: 'watch',
    }.to_json

    stub_request(:get, %r{weather-alerts\.com\/api\?zip_code=20000})
      .and_return(status: 200, body: body)
  end

  def stub_warning_request
    body = {
      zip_code: '30000',
      status: 'warning',
    }.to_json

    stub_request(:get, %r{weather-alerts\.com\/api\?zip_code=30000})
      .and_return(status: 200, body: body)
  end
end
