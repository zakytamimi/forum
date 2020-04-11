class GantiTypeData < ActiveRecord::Migration[6.0]
  def change
    change_column :forum_threads, :sticky_order, :integer, default: 100
  end
end
