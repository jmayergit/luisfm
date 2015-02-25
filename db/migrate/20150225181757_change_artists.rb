class ChangeArtists < ActiveRecord::Migration
  def change
    add_column :artists, :image, :string
  end
end
