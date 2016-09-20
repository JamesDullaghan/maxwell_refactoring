class AdminEmailValidationService
  attr_reader :user, :admins

  def initialize(user: user)
    @user = user
    @admins = Person.admins
  end

  def call!
    # validated user is sent to admin
    Emails.admin_user_validated(admins, user)
    # user welcome email sent
    Emails.welcome(user).deliver!
  end
end
