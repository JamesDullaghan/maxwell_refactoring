class EmailValidationService
  attr_reader :user, :admins

  def initialize(user: user)
    @user = user
    @admins = Person.admins
  end

  def call!
    Emails.admin_user_validated(admins, user)
    Emails.welcome(user).deliver!
  end
end
