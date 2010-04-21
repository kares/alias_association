ActiveRecord::Schema.define do
  
  create_table :users, :force => true do |t|
  end

  create_table :names, :force => true do |t|
    t.column :u_id, :integer
  end
  
  create_table :roles, :force => true do |t|
    t.references :user
  end

  create_table :rights, :force => true do |t|
  end

  create_table :roles_rights, :force => true do |t|
    t.references :role
    t.references :right
  end
  
end