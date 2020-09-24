class RenamePrefecturesColumnToAddresses < ActiveRecord::Migration[6.0]
  def change
    rename_column :addresses, :prefectures, :prefectures_id
  end
end
