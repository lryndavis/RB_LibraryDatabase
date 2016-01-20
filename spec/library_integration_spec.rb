require('capybara/rspec')
require('./app')
require('./spec/spec_helper')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('adding an author', {:type => :feature}) do
  it('allows a librarian to add a new author to the database') do
    visit('/')
    click_link('Librarian Portal')
    click_link('Add a Book')
    select('New Author')
    fill_in('first_name', :with => 'Charlotte')
    fill_in('last_name', :with => 'Bronte')
    fill_in('title', :with => 'Jane Eyre')
    click_button('Add')
    expect(page).to(have_content('Bronte, Charlotte'))
  end
end
