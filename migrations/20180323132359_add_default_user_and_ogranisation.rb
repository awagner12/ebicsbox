Sequel.migration do
  up do
    orga_id = self[:organizations].insert(name: 'Primary Organization', webhook_token: SecureRandom.hex(24)) unless self[:organizations].any?

    if self[:users].any?
      self[:users].insert(organization_id: orga_id, name: 'Primary user', admin: true)
    end
  end
end
