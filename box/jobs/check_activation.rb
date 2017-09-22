require_relative '../queue'
require_relative '../models/subscriber'

module Box
  module Jobs
    class CheckActivation
      def self.process!(message)
        subscriber = Subscriber.find(id: message[:subscriber_id])
        if subscriber.activate!
          Box.logger.info("[Jobs::CheckActivation] Activated subscriber! subscriber_id=#{subscriber.id}")
        else
          Queue.check_subscriber_activation(subscriber.id, subscriber.account.config.activation_check_interval)
          Box.logger.info("[Jobs::CheckActivation] Failed to activate subscriber! subscriber_id=#{subscriber.id}")
        end
      end
    end
  end
end