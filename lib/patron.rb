class Patron
  attr_reader(:id, :first_name, :last_name)

  def initialize(arguments)
    @id = arguments[:id]
    @first_name = arguments[:first_name]
    @last_name = arguments[:last_name]
  end

  def save
    result = DB.exec("INSERT INTO patrons (first_name, last_name) \
      VALUES ('#{@first_name}', '#{@last_name}') RETURNING id; ")
    @id = result.first.fetch('id').to_i()
  end

  def self.all
    results = DB.exec("SELECT * FROM patrons;")
    Patron.map_results_to_objects(results)
  end

  def self.map_results_to_objects(results)
    objects = []
    results.each() do |result|
      id = result.fetch('id').to_i()
      first_name = result.fetch('first_name')
      last_name = result.fetch('last_name')
      objects << Patron.new({
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
      DB.exec("UPDATE patrons SET #{column} = '#{new_value}' WHERE id = #{@id};")
    end
  end

  def checkout_books(attributes, due_date)
    attributes.fetch(:book_ids, []).each() do |book_id|
      DB.exec("INSERT INTO checkouts (book_id, patron_id, due_date, checked_out) \
        VALUES (#{book_id.to_i()}, #{self.id()}, '#{due_date}', 't');")
    end
  end

  def book_history
    history_results = DB.exec("SELECT books.* FROM patrons
      JOIN checkouts ON (patrons.id = checkouts.patron_id)
      JOIN books ON (checkouts.book_id = books.id)
      WHERE patrons.id = #{self.id()};")

    books = Book.map_results_to_objects(history_results)
    history = {}

    books.each() do |book|
      due_date_result = DB.exec("SELECT due_date FROM checkouts \
        WHERE book_id = #{book.id()} AND patron_id = #{self.id()}").first()
      due_date = due_date_result.fetch('due_date')
      history.store(book.id(), due_date)
    end
    history
  end

  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()}")
  end

  def ==(another_patron)
    self.id() == another_patron.id()
  end

  def self.sort_by(column, direction)
    results = DB.exec("SELECT * FROM patrons ORDER BY #{column} #{direction};")
    Patron.map_results_to_objects(results)
  end

  def self.find(column, identifier)
    if identifier.is_a?(String)
      results = DB.exec("SELECT * FROM patrons WHERE #{column} = '#{identifier}';")
    else
      results = DB.exec("SELECT * FROM patrons WHERE #{column} = #{identifier};")
    end
    Patron.map_results_to_objects(results)
  end
end
