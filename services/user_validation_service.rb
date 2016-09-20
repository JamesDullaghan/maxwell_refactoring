class UserValidationService
  attr_reader :user

  def initialize(user: user)
    @user = user
  end

  def call!
    user.validate!
    email_validation_service.call!
  end

  private

  def email_validation_service
    AdminEmailValidationService.new(user: user)
  end
end
