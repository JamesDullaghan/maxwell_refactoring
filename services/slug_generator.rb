class SlugGenerator
  def self.generate!
    "ABC123#{current_time}1239827#{random_number}"
  end

  private

  def current_time
    Time.now.to_i.to_s
  end

  def random_number
    rand(10000)
  end
end
