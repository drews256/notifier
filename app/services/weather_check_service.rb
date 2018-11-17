class WeatherCheckService
  attr_reader :webhooks, :payload, :body

  def initialize(**params)
    @payload = params[:payload]
  end

  def call
    parse_payload
    @webhooks = Webhook.where(zip_code: zip_code)
    wehbooks.each do |webhook|
      post_weather_alert
      create_webhook_event
    end
  end

  def post_weather_alert
    @response = HTTParty.post(request_url)
  end

  def parse_payload
    @body = JSON.parse(payload)[:zip_code]
  end

  def create_webhook_event
    WebhookEvent.create!(
      {
        webhook_id: webhook_id,
        status: response.code,
        response: response
      }
    )
  end

  def request_url
    return unless webhook
    webhook.url
  end
end
