require('spec_helper')

describe(Author) do
  describe('#initialize') do
    it('creates a new author and allows us to access her characteristics') do
      test_author = create_test_author()
      expect(test_author.first_name()).to(eq('Charlotte'))
      expect(test_author.last_name()).to(eq('Bronte'))
    end
  end

  describe('#id') do
    it('sets its ID when you save it') do
      test_author = create_test_author()
      test_author.save()
      expect(test_author.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe('#save') do
    it('saves the author to the database') do
      test_author = create_test_author()
      test_author.save()
      expect(Author.all()).to(eq([test_author]))
    end
  end
end
