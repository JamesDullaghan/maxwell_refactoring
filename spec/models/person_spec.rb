describe Person, type: :model do
  # use shoulda-matchers here for model
  # validations and association checks
  # NOTE: Not sure which attrs are to be validated
  [:first_name, :last_name, :email].each do |attr|
    it { is_expected.to validate_presence_of(attr) }
  end

  # Would use factorygirl for factories
  describe '.admin' do
    context 'with admins' do
      # could use create_list, forgot syntax :)
      let(:admin1) { create(:person, :admin) }
      let(:admin2) { create(:person, :admin) }

      it 'returns admins' do
        expect(described_class.admins).to match_array([admin1, admin2])
      end
    end

    context 'with a non admin' do
      let(:admin1)   { create(:person, :admin) }
      let(:nonadmin) { create(:person)         }

      it 'does not return non admin' do
        expect(described_class.admins).to not_include nonadmin
      end
    end
  end

  describe '.admin_emails' do
    context 'with admins' do
      let(:admin1) { create(:person, :admin, email: 'bart@simpson.com') }
      let(:admin2) { create(:person, :admin, email: 'lisa@simpson.com') }

      it 'returns admins emails as an array' do
        expect(described_class.admin_emails).to match_array(['bart@simpson.com', 'lisa@simpson.com'])
      end
    end

    context 'without admins' do
      it 'returns an empty array' do
        expect(described_class.admin_emails).to match_array([])
      end
    end
  end

  describe '.increment_person' do
    let(:people) { create_list(:person, 2) }

    it 'increments the persons count by one' do
      expect(described_class.increment_person).to eq 3
    end
  end

  describe '.odd?' do
    context 'if increment person is odd' do
      it 'returns true' do
        expect(described_class.odd?).to eq true
      end
    end

    context 'if increment person is even' do
      let(:people) { create_list(:person, 1) }

      it 'returns false' do
        expect(described_class.odd?).to eq false
      end
    end
  end

  describe '.unvalidated' do
    # TODO: Make factories with invalid traits to dry this up
    let(:created) { DateTime.current - 10.days }
    let(:invalid) { DateTime.current - 45.days }

    let(:person1) { create(:person, validated: false, created_at: created) }
    let(:person2) { create(:person, validated: false, created_at: created) }
    let(:person3) { create(:person, validated: true, created_at: invalid)  }

    it 'returns only unvalidated people' do
      expect(described_class.unvalidated).to match_array([person1, person2])
    end

    it 'returns only people created less than 30 days ago' do
      expect(described_class.unvalidated).to match_array([person1, person2])
    end
  end

  describe '#validate!' do
    let(:person) { create(:person, validated: false) }
    subject { person }

    before do
      expect(Rails.logger).to receive(:info).with(/validated email successfully./).and_call_original
    end

    it 'saves a user' do
      expect(subject.validate!).to eq true
    end

    it 'sets the validated attribute to true' do
      expect(subject.validated).to eq true
    end
  end

  describe '#destroy_with_logger_output' do
    let(:person) { create(:person, email: 'homer@simpson.com') }
    subject { person }

    before do
      expect(Rails.logger).to receive(:info).with(/Removing unvalidated user/).and_call_original
    end

    it 'destroys the user' do
      expect(subject.destroy_with_logger_output).to eq subject
    end
  end
end
