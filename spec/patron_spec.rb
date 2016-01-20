require('spec_helper')

describe(Patron) do
  describe('#initialize') do
    it('creates a new patron and allows us to access her characteristics') do
      test_patron = create_test_patron()
      expect(test_patron.first_name()).to(eq('Madeleine'))
      expect(test_patron.last_name()).to(eq('Albright'))
    end
  end

  describe('#id') do
    it('sets its ID when you save it') do
      test_patron = create_test_patron()
      test_patron.save()
      expect(test_patron.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe('#save') do
    it('saves the patron to the database') do
      test_patron = create_test_patron()
      test_patron.save()
      expect(Patron.all()).to(eq([test_patron]))
    end
  end

  describe('.sort_by') do
    it('sorts patrons by the specified column in the specified direction') do
      madeleine_albright = create_test_patron()
      madeleine_albright.save()
      notorious_rbg = create_second_patron()
      notorious_rbg.save()
      expect(Patron.sort_by('last_name', 'ASC'))
        .to(eq([madeleine_albright, notorious_rbg]))
      expect(Patron.sort_by('last_name', 'DESC'))
        .to(eq([notorious_rbg, madeleine_albright]))
      expect(Patron.sort_by('first_name', 'ASC'))
        .to(eq([madeleine_albright, notorious_rbg]))
    end
  end

  describe('.find') do
    it('finds patrons by the specified criteria') do
      madeleine_albright = create_test_patron()
      madeleine_albright.save()
      notorious_rbg = create_second_patron()
      notorious_rbg.save()
      expect(Patron.find('id', madeleine_albright.id)).to(eq([madeleine_albright]))
      expect(Patron.find('last_name', madeleine_albright.last_name)).to(eq([madeleine_albright]))
    end
  end

  describe('#update') do
    it('updates a specified attribute of the object') do
      test_patron = create_test_patron()
      test_patron.save()
      test_patron.update({
        :last_name => 'Albrightsaurus'
        })
      updated_patron = Patron.find('id', test_patron.id()).first()
      expect(updated_patron.last_name()).to(eq('Albrightsaurus'))
      expect(updated_patron.first_name()).to(eq('Madeleine'))
    end
  end

  describe('#delete') do
    it('lets you delete an patron from the database') do
      test_patron = create_test_patron()
      test_patron.save()
      second_patron = create_second_patron()
      second_patron.save()
      test_patron.delete()
      expect(Patron.all()).to(eq([second_patron]))
    end
  end
end
