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
  @results = Book.all()
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

delete('/books/:id') do
  id = params[:id]
  book = Book.find('id', id).first()
  book.delete()
  message = 'A book has been deleted.'
  redirect("/books?message=#{message}")
end

get('/search') do
  search_type = params[:search_type]
  search_criteria = params[:search_criteria]
  @results = Book.find("#{search_type}", "#{search_criteria}")
  erb(:books)
end
