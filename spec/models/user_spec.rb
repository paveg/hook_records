# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  let(:user) { build :user }
  let(:invalid_user) { User.new }
  let(:facebook_auth) { OmniAuth::AuthHash.new(JSON.load(File.read(Rails.root.join('spec/fixtures/facebook_auth.json')))) }
  context 'when invalid' do
    it { expect(invalid_user).to be_invalid }
  end
  context 'when valid' do
    it do
      # User model needs email and password.
      expect(user).to have_attributes(
                        email: 'test@example.com',
                        password: 'testtest'
                      )
      expect(user).to be_valid
      # execute User#save is create new record.
      expect { user.save }.to change { User.count }.by(1)
      # execute User#destroy is delete record.
      expect { user.destroy }.to change { User.count }.by(-1)
    end
  end

  describe '.find_or_create_for_oauth!' do
    subject { User.find_or_create_for_oauth!(facebook_auth) }

    context 'when access new user' do
      it do
        expect { subject }.to change { User.count }.by(1)
        is_expected.to be_kind_of(described_class)
        expect(subject).to have_attributes(email: 'test@example.com')
        expect(subject.social_profiles.count).to eq(1)
        expect(subject.social_profiles).to be_present
      end
    end
    context 'when user exists' do
      before { create :user }
      it do
        expect { subject }.not_to change { User.count }
        is_expected.to be_kind_of(described_class)
        expect(subject).to have_attributes(email: 'test@example.com')
        expect(subject.social_profiles.count).to eq(1)
        expect(subject.social_profiles).to be_present
      end
    end
    context ''
  end
end
