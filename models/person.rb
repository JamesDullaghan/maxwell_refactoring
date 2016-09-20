class Person < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  scope :admins, -> { where(admin: true) }
  scope :increment_person, -> { (count(:all) + 1) }
  scope :odd?, -> { increment_person.odd? }

  def validate!
    self.validated = true
    self.save
    Rails.logger.info "USER: User ##{self.id} validated email successfully."
  end
end
