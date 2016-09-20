describe Person, type: :model do
  # use shoulda-matchers here for model
  # validations and association checks
  # NOTE: Not sure which attrs are to be validated
  [:first_name, :last_name, :email].each do |attr|
    it { is_expected.to validate_presence_of(attr) }
  end




end
