class WeatherCheckService
  include Sidekiq::Worker
  attr_reader :webhooks, :payload, :response,
    :zip_code, :status, :webhook

  def perform(payload)
    @payload = payload
    parse_payload
    @webhooks = Webhook.where(zip_code: zip_code)
    return if webhooks.blank?
    webhooks.each do |webhook|
      @webhook = webhook
      post_weather_alert
      create_webhook_event
    end
  end

  def body
    { zip_code: zip_code, status: status }
  end

  def parse_payload
    body = JSON.parse(payload)
    @zip_code = body['zip_code']
    @status = body['status']
  end

  def post_weather_alert
    @response = HTTParty.post(request_url, body)
  end

  def create_webhook_event
    WebhookEvent.create!(
      {
        webhook_id: webhook.id,
        status: response&.code,
        response: response
      }
    )
  end

  def request_url
    webhook.url
  end
end
