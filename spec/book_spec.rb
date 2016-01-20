require('spec_helper')

describe(Book) do
  describe('#initialize') do
    it('creates a new book and allows us to access its characteristics') do
      test_book = create_test_book()
      expect(test_book.title()).to(eq('Jane Eyre'))
    end
  end

  describe('#id') do
    it('sets its ID when you save it') do
      test_book = create_test_book()
      test_book.save()
      expect(test_book.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe('#save') do
    it('saves the book to the database') do
      test_book = create_test_book()
      test_book.save()
      expect(Book.all()).to(eq([test_book]))
    end
  end

  describe('.sort_by') do
    it('sorts books by the specified column in the specified direction') do
      jane_eyre = create_test_book()
      jane_eyre.save()
      phantoms = create_second_book()
      phantoms.save()
      expect(Book.sort_by('title', 'ASC'))
        .to(eq([jane_eyre, phantoms]))
      expect(Book.sort_by('title', 'DESC'))
        .to(eq([phantoms, jane_eyre]))
    end
  end

  describe('.find') do
    it('finds books by the specified criteria') do
      jane_eyre = create_test_book()
      jane_eyre.save()
      phantoms = create_second_book()
      phantoms.save()
      expect(Book.find('id', jane_eyre.id)).to(eq([jane_eyre]))
      expect(Book.find('title', jane_eyre.title())).to(eq([jane_eyre]))
    end
  end

  describe('#update') do
    it('updates a specified attribute of the object') do
      test_book = create_test_book()
      test_book.save()
      test_book.update({
        :title => 'Jayne Eyre'
        })
      updated_book = Book.find('id', test_book.id()).first()
      expect(updated_book.title()).to(eq('Jayne Eyre'))
    end
  end

  describe('#delete') do
    it('lets you delete a book from the database') do
      test_book = create_test_book()
      test_book.save()
      second_book = create_second_book()
      second_book.save()
      test_book.delete()
      expect(Book.all()).to(eq([second_book]))
    end
  end
end
