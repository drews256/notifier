class WeatherJob
  include Sidekiq::Worker
  REQUIRED_PARAMS = %w(zip_code).freeze
  BASE_URL = 'https://weather-alerts.com/api'.freeze
  #  TODO:  <17-11-18, andrew stuntz> # get more info on api
  VALID_RESPONSE_CODES = %(200 400 403 404 500 503).freeze
  attr_reader :webhook, :errors, :params,
    :response, :zip_code

  def perform(zip_code)
    setup(zip_code)
    return notify_and_kill if errors.present?
    get_weather
    parse_response
  rescue Webhooks::WebhooksError
    reschedule
  end

  def get_weather
    @response = HTTParty.get(request_url)
  end

  def handle_200_response
    reschedule
    notify_valid_response
  end

  def parse_response
    return handle_200_response if response.code == 200
    handle_non_200_response
  end

  def handle_non_200_response
    raise Webhooks::InvalidResponseCode, 'Invalid response code' unless VALID_RESPONSE_CODES.include?(response.code.to_s)
    raise error.constantize if error_response_by_code.keys.include(response.code.to_i)
    raise Webhooks::WebhooksError, 'Something went wrong with request'
  end

  def error_response_by_code
    {
      '400': 'Webhooks::InvalidRequest',
      '403': 'Webhooks::AuthenticationFailure',
      '404': 'Webhooks::ResourceNotFound',
      '500': 'Webhooks::SystemException',
      '503': 'Webhooks::ServiceTemporarilyUnavailable',
    }.with_indifferent_access
  end

  def setup(zip_code)
    @errors = {}
    @zip_code = zip_code
    validate_required_params
  end

  def reschedule
    self.class.perform_at(5.minutes.from_now, zip_code)
  end

  def request_url
    BASE_URL + "?zip_code=#{zip_code}"
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

  def notify_valid_response
    ActiveSupport::Notifications.instrument('webhook.success') do |instrument|
      instrument[:payload] = {
        webhook_job_status: 'success',
        webhook_job_response: response&.body,
        webhook_zip_code: zip_code,
        webhook_job_id: jid,
      }
    end
  end

  def notify_and_kill
    ActiveSupport::Notifications.instrument('webhook.error') do |instrument|
      instrument[:payload] = {
        webhook_job_status: 'error',
        webhook_job_errors: errors,
        webhook_zip_code: zip_code,
        webhook_job_id: jid,
      }
    end
  end
end
