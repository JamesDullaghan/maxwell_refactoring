class PersonCreatorService
  attr_reader :person

  def initialize(person: person)
    @person = person
  end

  def call!
    person_attrs = PersonMetaDataService.new.call!
    person.attributes = person_attrs
    person.save
  end
end
