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

  def ==(another_author)
    self.id() == another_author.id() 
  end
end
