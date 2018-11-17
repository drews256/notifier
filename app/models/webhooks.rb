module Webhooks
  class WebhooksError < StandardError
    def initialize(message = 'Webhook Failed')
      ActiveSupport::Notifications.instrument('webhook.error') do |payload|
        payload[:message] = message
      end
      super(message)
    end
  end

  class InvalidResponseCode < WebhooksError; end
  class InvalidRequest < WebhooksError; end
  class AuthenticationFailure < WebhooksError; end
  class ResourceNotFound < WebhooksError; end
  class SystemException < WebhooksError; end
  class ServiceTemporarilyUnavailable < WebhooksError; end
end
