class UserEmailValidationService
  attr_reader :user, :admin_emails

  def initialize(user: user)
    @user = user
    @admin_emails = Person.admin_emails
  end

  def call!
    # Validate users email
    Emails.validate_email(user).deliver
    # alert admin of a new user?
    Emails.admin_new_user(admin_emails, user).deliver
  end
end
