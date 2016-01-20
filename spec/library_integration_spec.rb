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

describe('adding a book', {:type => :feature}) do
  it('allows a librarian to add a book to an existing author') do
    create_test_author().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Add a Book')
    select('Bronte, Charlotte')
    fill_in('title', :with => 'Jane Eyre')
    click_button('Add')
    expect(page).to(have_content('Jane Eyre'))
  end
end

describe('search for a book', {:type => :feature}) do
  it('allows a user to search for a book by title') do
    create_test_book().save()
    visit('/')
    select('Title')
    fill_in('search_criteria', :with => 'Jane Eyre')
    click_button('Search')
    expect(page).to(have_content('Jane Eyre'))
  end
end

describe('delete a book', {:type => :feature}) do
  it('allows a librarian to delete a book') do
    create_test_book().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Manage Books')
    click_button('Remove Book from Database')
    expect(page).to(have_content('A book has been deleted.'))
    expect(page).not_to(have_content('Jane Eyre'))
  end
  it('will not allow a patron to delete a book') do
    create_test_book().save()
    visit('/')
    click_link('Browse All Books')
    expect(page).to(have_content('Jane Eyre'))
    expect(page).not_to(have_content('Remove Book from Database'))
  end
end

describe('edit a book', {:type => :feature}) do
  it('allows a librarian to edit a book title') do
    create_test_book().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Manage Books')
    click_link('Update Book Information')
    fill_in('title', :with => 'Jayne Eyre')
    click_button('Update Book Information')
    expect(page).to(have_content('Jayne Eyre'))
  end
end
