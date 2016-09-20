class Person < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  scope :admins, -> { where(admin: true) }
  scope :admin_emails, -> { admins.collect { |a| a.email } rescue [] }
  # TODO: Poor Name, we're not incrementing person,
  #   we are incrementing person count
  scope :increment_person, -> { (count(:all) + 1) }
  scope :odd?, -> { increment_person.odd? }
  scope :unvalidated, -> (days_ago = 30.days) {
    where('created_at < ? AND validated IS false', DateTime.current - days_ago)
  }
  scope :destroy_people_with_logger_output, -> {
    each { |person| person.destroy_with_logger_output }
  }


  def validate!
    self.validated = true
    self.save
    Rails.logger.info "USER: User ##{id} validated email successfully."
  end

  # TODO: Again terrible naming for the sake of time
  def destroy_with_logger_output
    Rails.logger.info "Removing unvalidated user #{email}"
    self.destroy
  end
end
