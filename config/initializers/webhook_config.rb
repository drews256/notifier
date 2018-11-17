WEBHOOK_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/webhooks.yml")

Rails.application.config.after_initialize do
  Webhook.all.destroy_all
  WEBHOOK_CONFIG.keys.each do |key|
    webhook = WEBHOOK_CONFIG[key]
    Webhook.create!(webhook)
  end
end
