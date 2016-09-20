class PersonMetaDataService
  def call!
    { slug: slug, admin: admin?, team: team, handle: handle }
  end

  private

  def odd?
    Person.odd?
  end

  def admin?
    false
  end

  def slug
    @slug ||= SlugGenerator.generate!
  end

  def incremented_person_count
    @incremented_person_count ||= Person.increment_person
  end

  def team
    odd? ? "UnicornRainbows" : "LaserScorpions"
  end

  def handle
    "#{team}#{incremented_person_count}"
  end
end
