class AddColumn < ActiveRecord::Migration
  def change
    add_column :artists, :ytid, :string
  end
end
