ActiveRecord::Schema.suppress_messages do
  ActiveRecord::Schema.define do
    create_table :widgets do |t|
      t.boolean :deleted, :default => false
      t.timestamps
    end
  end
end
