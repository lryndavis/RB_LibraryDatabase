require('rspec')
require('pg')
require('author')
require('book')
require('patron')
require('pry')

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM books *;")
  end
end

def create_test_author
  Author.new({
    :id => nil,
    :first_name => 'Charlotte',
    :last_name => 'Bronte'})
end
