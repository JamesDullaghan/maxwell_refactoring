class EmailValidationController < ActionController::Base
  def update
    return unless user.present?

    user_validation_service = UserValidationService.new(user: user)
    user_validation_service.call!
  end

  private

  def user
    Person.find_by(slug: params[:slug])
  end
end
