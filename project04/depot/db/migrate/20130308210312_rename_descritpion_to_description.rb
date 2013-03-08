class RenameDescritpionToDescription < ActiveRecord::Migration
  def up
  	rename_column :Products, :descritption, :description
  end

  def down
  end
end
