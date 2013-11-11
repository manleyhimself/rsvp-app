class AddIpToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :ip, :integer
  end
end
