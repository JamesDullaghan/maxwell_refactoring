class PeoplesController < ActionController::Base
  def create
    if person_creator_service.call!
      redirect_to person, notice "Account added!"
    else
      render :new
    end
  end

  private

  def person_creator_service
    PersonCreatorService.new(person: person)
  end

  def person
    @person ||= Person.new(permitted_params)
  end

  def permitted_params
    params.require(:person).permit(
      :first_name,
      :last_name,
      :email,
      :admin,
      :slug,
      :validated,
      :handle,
      :team
    )
  end
end
