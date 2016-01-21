require('capybara/rspec')
require('./app')
require('./spec/spec_helper')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('adding an author', {:type => :feature}) do
  it('allows a librarian to add a new book and author to the database') do
    visit('/')
    click_link('Librarian Portal')
    click_link('Add a Book')
    fill_in('first_name1', :with => 'Charlotte')
    fill_in('last_name1', :with => 'Bronte')
    fill_in('title', :with => 'Jane Eyre')
    click_button('Add')
    expect(page).to(have_content('Bronte, Charlotte'))
    visit('/books')
    expect(page).to(have_content('Bronte, Charlotte'))
  end
end

describe('adding a book', {:type => :feature}) do
  it('allows a librarian to add a book to an existing author') do
    first_author = create_test_author()
    first_author.save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Add a Book')
    check('Bronte, Charlotte')
    fill_in('title', :with => 'Jane Eyre')
    click_button('Add')
    expect(page).to(have_content('Jane Eyre'))
  end

  it('allows a librarian to add multiple existing authors to a book') do
    second_author = create_second_author()
    second_author.save()
    create_test_author().save()
    visit('/books/new')
    check('Bronte, Charlotte')
    check('Koontz, Dean')
    fill_in('title', :with => 'Jane Eyre')
    click_button('Add')
    expect(page).to(have_content('Bronte, Charlotte'))
    expect(page).to(have_content('Koontz, Dean'))
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

describe('adding a patron', {:type => :feature}) do
  it('allows a librarian to add a new patron to the database') do
    visit('/')
    click_link('Librarian Portal')
    click_link('Add a Patron')
    fill_in('first_name', :with => 'Madeleine')
    fill_in('last_name', :with => 'Albright')
    click_button('Add')
    expect(page).to(have_content('Albright, Madeleine'))
  end
end

describe('delete a patron', {:type => :feature}) do
  it('allows a librarian to delete a patron') do
    create_test_patron().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Manage Patrons')
    click_button('Remove Patron from Database')
    expect(page).to(have_content('A patron has been deleted.'))
    expect(page).not_to(have_content('Albright, Madeleine'))
  end
end

describe('edit a patron', {:type => :feature}) do
  it('allows a librarian to edit patron information') do
    create_test_patron().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Manage Patrons')
    click_link('Update Patron Information')
    fill_in('first_name', :with => 'Jayne')
    click_button('Update Patron Information')
    expect(page).to(have_content('Albright, Jayne'))
  end
end

describe('delete an author', {:type => :feature}) do
  it('allows a librarian to delete an author') do
    create_test_author().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Manage Authors')
    click_button('Remove Author from Database')
    expect(page).to(have_content('An author has been deleted.'))
    expect(page).not_to(have_content('Bronte, Charlotte'))
  end
end

describe('edit an author', {:type => :feature}) do
  it('allows a librarian to edit author information') do
    create_test_author().save()
    visit('/')
    click_link('Librarian Portal')
    click_link('Manage Authors')
    click_link('Update Author Information')
    fill_in('first_name', :with => 'Jayne')
    click_button('Update Author Information')
    expect(page).to(have_content('Bronte, Jayne'))
  end
end
