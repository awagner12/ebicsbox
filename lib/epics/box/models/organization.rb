require 'epics/box/models/account'

module Epics
  module Box
    class Organization < Sequel::Model
      self.raise_on_save_failure = true

      one_to_many :accounts
      one_to_many :users

      def find_account!(iban)
        accounts_dataset.first!(iban: iban)
      rescue Sequel::NoMatchingRow => ex
        fail Account::NotFound.for_orga(organization_id: self.id, iban: iban)
      end
    end
  end
end
