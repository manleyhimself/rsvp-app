class Invite < ActiveRecord::Base
  belongs_to :event

  def verify_ip(ip) 
    if ip_exist(ip).length > 0
     name_ip_match(ip)
    else
      self.update(ip: ip)
      true
    end
  end

  def ip_exist(ip)
    Invite.where(ip: ip)
  end


  def name_ip_match(ip)
    if ip_exist(ip).detect { |invite| invite.name == self.name }
      self.update(ip: ip)
      true
    else
      false
    end
  end

end
