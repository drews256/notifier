class WeatherCheckService
  def initialize(**params)
    @webhook_ids = Webhook.all.pluck(:id)
  end

  def call
    webhook_ids.map { |webhook_id| WebhookJob.perform(webhook_id) }
  end
end
