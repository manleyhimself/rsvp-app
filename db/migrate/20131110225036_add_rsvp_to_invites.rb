class AddRsvpToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :rsvp, :boolean
  end
end
