require 'sequel'

DB = Sequel.sqlite('rack_app.db') # memory database, requires sqlite3

DB.create_table :users do
  primary_key :id
  String :name
end

users = DB[:users] # Create a dataset

# Populate the table
users.insert(:name => 'Arvind Mehra')
users.insert(:name => 'Rakesh Sharma')
users.insert(:name => 'Mark Zuckerberg')
users.insert(:name => 'Bill Gates')
users.insert(:name => 'Kalpana Chawla')
users.insert(:name => 'Elon Musk')
users.insert(:name => 'Zeff Bezos')
users.insert(:name => 'Narendra Modi')

# Print out the number of records
puts "Users count: #{users.count}"