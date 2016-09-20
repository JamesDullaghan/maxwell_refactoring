class RemoveUnvalidatedPeopleService
  attr_reader :people, :admins

  def initialize(people: people)
    @people = Person.unvalidated
    @admins = Person.admins
  end

  def self.call!
    unvalidated_people_service = self.class.new

    ActiveRecord::Base.transaction do
      people = unvalidated_people_service.people
      admins = unvalidated_people_service.admins

      people.destroy_unvalidated
      Emails.admin_removing_unvalidated_users(admins, people).deliver
    end
  end
end
