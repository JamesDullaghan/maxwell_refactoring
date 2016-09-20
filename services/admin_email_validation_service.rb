class AdminEmailValidationService
  attr_reader :user, :admin_emails

  def initialize(user: user)
    @user = user
    @admin_emails = Person.admin_emails
  end

  def call!
    # validated user is sent to admin
    Emails.admin_user_validated(admin_emails, user)
    # user welcome email sent
    Emails.welcome(user).deliver!
  end
end
