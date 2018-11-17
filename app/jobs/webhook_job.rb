class WebhookJob
  include Sidekiq::Worker
  REQUIRED_PARAMS = %w(webhook_id)
  attr_reader :webhook, :errors, :params,
    :response, :webhook_id

  def perform(webhook_id)
    setup(webhook_id)
    return notify_and_kill if errors.present?
    get_weather
    parse_response
  rescue Http
  end

  def get_weather
    @response = HTTParty.get(request_url)
  end

  def parse_response
    return chase_response if response_code == 200
    handle_non_200_response
  end

  def handle_non_200_response
    raise InvalidChaseResponseCode, 'Invalid response code' unless VALID_RESPONSE_CODES.include?(response_code.to_s)
    raise error.constantize if error
    raise StandardError, 'Something went wrong with Chase request'
  end

  def error_response_by_code
    {
      '400': 'InvalidRequest',
      '403': 'AuthenticationFailure',
      '404': 'ResourceNotFound',
      '500': 'SystemException',
      '503': 'ServiceTemporarilyUnavailable'
    }.with_indifferent_access
  end

  def setup(webhook_id)
    @errors = {}
    @webhook_id = webhook_id
    @webhook = Webhook.find_by(id: webhook_id)
    validate_required_params
  end

  def reschedule
    self.class.perform_at(5.minutes.from_now, webhook_id)
  end

  def request_url
    return unless webhook
    webhook.url + "?zip_code=#{webhook.zip_code}"
  end

  def validate_required_params
    REQUIRED_PARAMS.each do |param|
      add_error(param) if send(param.to_sym).blank?
    end
  end

  def add_error(param)
    errors[param.to_sym] = "#{param} is missing"
  end

  def valid?
    errors.blank?
  end

  def notify_and_kill
    ActiveSupport::Notifications.instrument('webhook.error') do |instrument|
      instrument[:payload] = {
        webhook_job_status: 'error',
        webhook_job_errors: errors,
        webhook_job_webhook_id: webhook_id,
        webhook_job_id: jid,
      }
    end
  end
end
