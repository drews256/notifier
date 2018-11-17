require 'rails_helper'

describe WeatherCheckService do
  let!(:webhook) { create(:webhook) }

  before do
  stub_request(:post, "https://my-webhook.com/weather").
    with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }).
      to_return(status: 200, body: { status: '200' }.to_json, headers: {})
  end

  describe '.perform' do
    it 'parses the zip code' do
      service = subject
      service.perform({ zip_code: '10000', status: 'quiet' }.to_json)
      expect(service.zip_code).to eq '10000'
    end

    it 'parses the status' do
      service = subject
      service.perform({ zip_code: '10000', status: 'quiet' }.to_json)
      expect(service.status).to eq 'quiet'
    end

    it 'finds webhooks' do
      service = subject
      service.perform({ zip_code: '10000', status: 'quiet' }.to_json)
      expect(service.webhooks).to include webhook
    end

    it 'posts to those webhooks' do
      service = subject
      expect(service).to receive(:post_weather_alert)
      service.perform({ zip_code: '10000', status: 'quiet' }.to_json)
    end

    it 'returns a response' do
      service = subject
      service.perform({ zip_code: '10000', status: 'quiet' }.to_json)
      expect(service.response.body).to eq({ status: '200' }.to_json)
    end

    it 'creates webhook events' do
      service = subject
      expect {
        service.perform({ zip_code: '10000', status: 'quiet' }.to_json)
      }.to change{ WebhookEvent.count }
    end
  end
end
