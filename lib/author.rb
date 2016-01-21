class Author
  attr_reader(:id, :first_name, :last_name)

  def initialize(arguments)
    @id = arguments[:id]
    @first_name = arguments[:first_name]
    @last_name = arguments[:last_name]
  end

  def save
    result = DB.exec("INSERT INTO authors (first_name, last_name) \
      VALUES ('#{@first_name}', '#{@last_name}') RETURNING id; ")
    @id = result.first.fetch('id').to_i()
  end

  def self.all
    results = DB.exec("SELECT * FROM authors;")
    Author.map_results_to_objects(results)
  end

  def self.map_results_to_objects(results)
    objects = []
    results.each() do |result|
      id = result.fetch('id').to_i()
      first_name = result.fetch('first_name')
      last_name = result.fetch('last_name')
      objects << Author.new({
        :id => id,
        :first_name => first_name,
        :last_name => last_name,
        })
    end
    objects
  end

  def update(attributes)
    @id = self.id()
    attributes.each() do |attribute|
      column = attribute[0].to_s()
      new_value = attribute[1]
      DB.exec("UPDATE authors SET #{column} = '#{new_value}' WHERE id = #{@id};")
    end
  end

  def books
    results = DB.exec("SELECT books.* FROM authors
      JOIN authorships ON (authors.id = authorships.author_id)
      JOIN books ON (authorships.book_id = books.id)
      WHERE authors.id = #{self.id()};")
    Book.map_results_to_objects(results)
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{self.id()}")
  end

  def ==(another_author)
    self.id() == another_author.id()
  end

  def self.sort_by(column, direction)
    results = DB.exec("SELECT * FROM authors ORDER BY #{column} #{direction};")
    Author.map_results_to_objects(results)
  end

  def self.find(column, identifier)
    if identifier.is_a?(String)
      results = DB.exec("SELECT * FROM authors WHERE #{column} = '#{identifier}';")
    else
      results = DB.exec("SELECT * FROM authors WHERE #{column} = #{identifier};")
    end
    Author.map_results_to_objects(results)
  end
end
