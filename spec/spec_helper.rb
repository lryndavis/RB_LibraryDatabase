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
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM authorships *;")
  end
end

def create_test_author
  Author.new({
    :id => nil,
    :first_name => 'Charlotte',
    :last_name => 'Bronte'})
end

def create_second_author
  Author.new({
    :id => nil,
    :first_name => 'Dean',
    :last_name => 'Koontz'})
end

def create_similarly_named_author
  Author.new({
    :id => nil,
    :first_name => 'Emily',
    :last_name => 'Bronte'})
end

def create_test_book
  Book.new({
    :id => nil,
    :title => 'Jane Eyre'})
end

def create_second_book
  Book.new({
    :id => nil,
    :title => 'Phantoms'})
end

def create_test_patron
  Patron.new({
    :id => nil,
    :first_name => 'Madeleine',
    :last_name => 'Albright'})
end

def create_second_patron
  Patron.new({
    :id => nil,
    :first_name => 'Ruth',
    :last_name => 'Bader Ginsberg'})
end
