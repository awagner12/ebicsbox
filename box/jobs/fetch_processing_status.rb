require 'nokogiri'

require_relative '../models/account'
require_relative '../models/transaction'

module Box
  module Jobs
    class FetchProcessingStatus
      def self.process!(message)
        log(:debug, "Check orders.")
        message[:account_ids].each do |account_id|
          log(:debug, "Reconciling orders by HAC.", { account_id: account_id })
          remote_records(account_id).each do |data|
            update_transaction(account_id, data)
          end
        end
      end

      def self.update_transaction(account_id, info)
        order_id = info[:ids]["OrderID"]
        if trx = Transaction.first(ebics_order_id: info[:ids]["OrderID"], account_id: account_id)
          trx.update_status(info[:action], reason: info[:reason_code])

          log(:info, "Transaction status change.", {
            account_id: account_id,
            ebics_order_id: order_id,
            transaction_id: trx.public_id,
            status: info[:action]
          })
        else
          log(:info, "Transaction not found.", { account_id: account_id, order_id: order_id, info: info })
        end
      end

      def self.remote_records(account_id)
        account = Account[account_id]
        file = account.transport_client.HAC
        Nokogiri::XML(file).remove_namespaces!.xpath("//OrgnlPmtInfAndSts").map do |info|
          {
            reason_code: info.xpath("./StsRsnInf/Rsn/Cd").text,
            action: info.xpath("./OrgnlPmtInfId").text.downcase,
            ids: info.xpath("./StsRsnInf/Orgtr/Id/OrgId/Othr").inject({}) do |memo, node|
              memo[node.at_xpath("./SchmeNm/Prtry").text] = node.at_xpath("./Id").text
              memo
            end
          }
        end
      end

      def self.log(type, message, data = {})
        data = data.map { |k, v| "#{k}=#{v}" }.join(' ')
        Box.logger.public_send(type, "[Jobs::FetchProcessingStatus] #{message} #{data}")
      end
    end
  end
end