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

  describe('.sort_by') do
    it('sorts authors by the specified column in the specified direction') do
      charlotte_bronte = create_test_author()
      charlotte_bronte.save()
      dean_koontz = create_second_author()
      dean_koontz.save()
      expect(Author.sort_by('last_name', 'ASC'))
        .to(eq([charlotte_bronte, dean_koontz]))
      expect(Author.sort_by('last_name', 'DESC'))
        .to(eq([dean_koontz, charlotte_bronte]))
      expect(Author.sort_by('first_name', 'ASC'))
        .to(eq([charlotte_bronte, dean_koontz]))
    end
  end

  describe('.find') do
    it('finds authors by the specified criteria') do
      charlotte_bronte = create_test_author()
      charlotte_bronte.save()
      dean_koontz = create_second_author()
      dean_koontz.save()
      expect(Author.find('id', charlotte_bronte.id)).to(eq([charlotte_bronte]))
      expect(Author.find('last_name', charlotte_bronte.last_name)).to(eq([charlotte_bronte]))
    end
  end

  describe('#update') do
    it('updates a specified attribute of the object') do
      test_author = create_test_author()
      test_author.save()
      test_author.update({
        :last_name => 'Brontesaurus'
        })
      updated_author = Author.find('id', test_author.id()).first()
      expect(updated_author.last_name()).to(eq('Brontesaurus'))
      expect(updated_author.first_name()).to(eq('Charlotte'))
    end
  end

  describe('#delete') do
    it('lets you delete an author from the database') do
      test_author = create_test_author()
      test_author.save()
      second_author = create_second_author()
      second_author.save()
      test_author.delete()
      expect(Author.all()).to(eq([second_author]))
    end
  end
end
