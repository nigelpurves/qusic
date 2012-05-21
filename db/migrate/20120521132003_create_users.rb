class CreateUsers < ActiveRecord::Migration
  def self.up  # self.up method uses a Rails method called create_table to create a db table for storing users; the use of 'self' identifies it as a class method
    create_table :users do |t|   # the create_table method accepts a block with one block variable, in this case t for table.
      t.string :name             # inside the block, the create_table method uses the t object to create name & email columns in the database, both of type 'string'
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
