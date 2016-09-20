class RemoveUnvalidatedPeopleService
  attr_reader :people, :admin_emails

  def initialize(people: people)
    @people = Person.unvalidated
    @admin_emails = Person.admin_emails
  end

  def self.call!
    unvalidated_people_service = self.class.new

    ActiveRecord::Base.transaction do
      people = unvalidated_people_service.people
      admins = unvalidated_people_service.admins

      people.destroy_people_with_logger_output
      Emails.admin_removing_unvalidated_users(admin_emails, people).deliver
    end
  end
end
