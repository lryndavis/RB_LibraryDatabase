require "sinatra"
require "sinatra/reloader"
require "./lib/author"
require "./lib/book"
require "./lib/patron"
require "pg"
require "pry"

DB = PG.connect({:dbname => 'library_test'})

get('/') do
  erb(:index)
end

get('/portal') do
  erb(:portal)
end

get('/books') do
  @user = params[:user]
  @results = Book.sort_by('title', 'ASC')
  @message = params[:message]
  erb(:books)
end

post('/books') do
  if params[:author_ids].nil?
    author_ids = []
  else
    author_ids = params[:author_ids]
  end

  if params[:last_name1].length() > 0
    first_name = params[:first_name1]
    last_name = params[:last_name1]
    author = Author.new({
      :id => nil,
      :first_name => first_name,
      :last_name => last_name
    })
    author.save()
    author_ids << author.id()
  end

  if params[:last_name2].length() > 0
    first_name = params[:first_name2]
    last_name = params[:last_name2]
    author = Author.new({
      :id => nil,
      :first_name => first_name,
      :last_name => last_name
    })
    author.save()
    author_ids << author.id()
  end

  title = params[:title]
  if title.length() > 0
    @book = Book.new({
      :id => nil,
      :title => title,
      })
    @book.save()

    @book.add_authors({:author_ids => author_ids})
    @authors = @book.authors()
  end

  erb(:success_temp)
end

get('/books/new') do
  @authors = Author.sort_by('last_name', 'ASC')
  erb(:book_form)
end

get('/books/:id') do
  id = params[:id]
  @book = Book.find('id', id).first()
  erb(:book)
end

patch('/books/:id') do
  id = params[:id]
  book = Book.find('id', id).first()
  title = params[:title]
  unless title == ""
    book.update({
      :title => title
      })
  end
  @book = Book.find('id', id).first()
  erb(:book)
end

delete('/books/:id') do
  id = params[:id]
  book = Book.find('id', id).first()
  book.delete()
  message = 'A book has been deleted.'
  redirect("/books?message=#{message}")
end

get('/books/:id/update') do
  id = params[:id]
  @book = Book.find('id', id).first()
  @authors = Author.sort_by('last_name', 'ASC')
  erb(:update_book_form)
end

get('/books/:id/checkout') do
  id = params[:id]
  @book = Book.find('id', id).first()
  erb(:checkout_book_form)
end

get('/search') do
  search_type = params[:search_type]
  search_criterium = params[:search_criteria]

  if search_type == "author"
    search_criteria = search_criterium.split(" ")
    authors = []
    @results = []
    search_criteria.each() do |criterium|
      first_name_matches = Author.find("first_name", criterium)
      last_name_matches = Author.find("last_name", criterium)

      if first_name_matches != []
        authors << first_name_matches
      end

      if last_name_matches != []
        authors << last_name_matches
      end
    end

    authors.flatten().each() do |author|
      author.books.each() do |book|
        unless @results.include?(book)
          @results << book
        end
      end
    end
  else
    @results = Book.find("#{search_type}", "#{search_criterium}")
  end
  erb(:books)
end

get('/patrons') do
  @user = params[:user]
  @message = params[:message]
  @results = Patron.sort_by('last_name', 'ASC')
  erb(:patrons)
end

post('/patrons') do
  first_name = params[:first_name]
  last_name = params[:last_name]

  Patron.new({
    :id => nil,
    :first_name => first_name,
    :last_name => last_name
  }).save()

  @results = Patron.sort_by('last_name', 'ASC')
  erb(:patrons)
end

get('/patrons/new') do
  erb(:patron_form)
end

delete('/patrons/:id') do
  id = params[:id]
  patron = Patron.find('id', id).first()
  patron.delete()
  message = 'A patron has been deleted.'
  redirect("/patrons?message=#{message}")
end

get('/patrons/:id/update') do
  id = params[:id]
  @patron = Patron.find('id', id).first()
  erb(:update_patron_form)
end

patch('/patrons/:id') do
  id = params[:id]
  patron = Patron.find('id', id).first()
  first_name = params[:first_name]
  last_name = params[:last_name]

  unless first_name == ""
    patron.update({
      :first_name => first_name
      })
  end

  unless last_name == ""
    patron.update({
      :last_name => last_name
      })
  end
  @patron = Patron.find('id', id).first()
  erb(:patron)
end

get('/authors') do
  @user = params[:user]
  @message = params[:message]
  @results = Author.sort_by('last_name', 'ASC')
  erb(:authors)
end

delete('/authors/:id') do
  id = params[:id]
  author = Author.find('id', id).first()
  author.delete()
  message = 'An author has been deleted.'
  redirect("/authors?message=#{message}")
end

get('/authors/:id/update') do
  id = params[:id]
  @author = Author.find('id', id).first()
  erb(:update_author_form)
end

patch('/authors/:id') do
  id = params[:id]
  author = Author.find('id', id).first()
  first_name = params[:first_name]
  last_name = params[:last_name]

  unless first_name == ""
    author.update({
      :first_name => first_name
      })
  end

  unless last_name == ""
    author.update({
      :last_name => last_name
      })
  end
  @author = Author.find('id', id).first()
  erb(:author)
end

post('/checkouts') do
  patron_id = params[:patron_id]
  book_id = params[:book_id]
  @patron = Patron.find('id', patron_id).first()
  @patron.checkout_books({:book_ids => [book_id]}, '2016-12-12')
  @book_history = @patron.book_history()
  erb(:checkouts)
end

get('/checkouts') do
  patron_id = params[:patron_id]
  @patron = Patron.find('id', patron_id).first()
  @book_history = @patron.book_history()
  erb(:checkouts)
end
