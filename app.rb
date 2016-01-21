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
  if params[:author] == "new"
    first_name = params[:first_name]
    last_name = params[:last_name]
    @author = Author.new({
      :id => nil,
      :first_name => first_name,
      :last_name => last_name
    })
    @author.save()
  else
    author_id = params[:author]
    @author = Author.find('id', author_id).first()
  end

  title = params[:title]
  @book = Book.new({
    :id => nil,
    :title => title,
    })
  @book.save()

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

get('/search') do
  search_type = params[:search_type]
  search_criteria = params[:search_criteria]
  @results = Book.find("#{search_type}", "#{search_criteria}")
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

  unless last_name = ""
    patron.update({
      :last_name => last_name
      })
  end
  @patron = Patron.find('id', id).first()
  erb(:patron)
end
