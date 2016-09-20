class Person < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  scope :admins, -> { where(admin: true) }
  scope :admin_emails, -> { admins.collect { |a| a.email } rescue [] }
  scope :increment_person, -> { (count(:all) + 1) }
  scope :odd?, -> { increment_person.odd? }
  scope :unvalidated, -> (days_ago = 30.days) { where('created_at < ?', DateTime.current - days_ago).where(validated: false) }
  scope :destroy_unvalidated, -> { each { |person| person.destroy_with_logger_output } }


  def validate!
    self.validated = true
    self.save
    Rails.logger.info "USER: User ##{id} validated email successfully."
  end

  def destroy_with_logger_output
    Rails.logger.info "Removing unvalidated user #{email}"
    self.destroy
  end
end
