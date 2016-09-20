class Emails < ActionMailer::Base
  default from: "from@example.com"

  def welcome(person)
    @person = person
    mail to: @person
  end

  def validate_email(person)
    @person = person
    mail to: @person
  end

  def admin_user_validated(admins, user)
    @admins = admins.admin_emails
    @user = user
    mail to: @admins
  end

  def admin_new_user(admins, user)
    @admins = admins.admin_emails
    @user = user
    mail to: @admins
  end

  def admin_removing_unvalidated_users(admins, users)
    @admins = admins.admin_emails
    @users = users
    mail to: @admins
  end
end
