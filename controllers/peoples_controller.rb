class PeoplesController < ActionController::Base
  def create
    @person.slug = slug
    @person.admin = false

    if Person.odd?
      team = "UnicornRainbows"
      handle = "UnicornRainbows" + incremented_person_count.to_s
      @person.handle = handle
      @person.team = team
    else
      team = "LaserScorpions"
      handle = "LaserScorpions" + incremented_person_count.to_s
      @person.handle = handle
      @person.team = team
    end

    # RETURN result of save from service


    if person_creator_service.call!

      Emails.validate_email(@person).deliver
      @admins = Person.where(:admin => true)
      Emails.admin_new_user(@admins, @person).deliver
      redirect_to @person, :notice => "Account added!"
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

  def slug
    @slug ||= SlugGenerator.generate!
  end

  def incremented_person_count
    @incremented_person_count ||= Person.increment_person
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
