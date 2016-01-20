class Book
  attr_reader(:id, :title)

  def initialize(arguments)
    @id = arguments[:id]
    @title = arguments[:title]
  end

  def save
    result = DB.exec("INSERT INTO books (title) \
      VALUES ('#{@title}') RETURNING id; ")
    @id = result.first.fetch('id').to_i()
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    Book.map_results_to_objects(results)
  end

  def self.map_results_to_objects(results)
    objects = []
    results.each() do |result|
      id = result.fetch('id').to_i()
      title = result.fetch('title')
      objects << Book.new({
        :id => id,
        :title => title
        })
    end
    objects
  end

  def update(attributes)
    @id = self.id()
    attributes.each() do |attribute|
      column = attribute[0].to_s()
      new_value = attribute[1]
      DB.exec("UPDATE books SET #{column} = '#{new_value}' WHERE id = #{@id};")
    end
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{self.id()}")
  end

  def ==(another_book)
    self.id() == another_book.id()
  end

  def self.sort_by(column, direction)
    results = DB.exec("SELECT * FROM books ORDER BY #{column} #{direction};")
    Book.map_results_to_objects(results)
  end

  def self.find(column, identifier)
    if identifier.is_a?(String)
      results = DB.exec("SELECT * FROM books WHERE #{column} = '#{identifier}';")
    else
      results = DB.exec("SELECT * FROM books WHERE #{column} = #{identifier};")
    end
    Book.map_results_to_objects(results)
  end
end
