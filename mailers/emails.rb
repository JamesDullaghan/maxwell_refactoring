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

  def admin_user_validated(admin_emails, user)
    @user = user
    mail to: admin_emails
  end

  def admin_new_user(admin_emails, user)
    @user = user
    mail to: admin_emails
  end

  def admin_removing_unvalidated_users(admin_emails, users)
    @users = users
    mail to: admin_emails
  end
end
