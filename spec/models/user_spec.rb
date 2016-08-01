require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject(:user) { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('example@domain.com').for(:email) }
  it { should validate_confirmation_of(:password) }
  it { should validate_uniqueness_of(:auth_token) }

  describe "#generate_authentication_token!" do
    subject(:auth_token) { @user.auth_token }
    let(:stubbed_token)  { "sometoken123" }

    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return(stubbed_token)
      puts "\n***"
      puts @user.generate_authentication_token!
      puts '***'
      expect(auth_token).to eql stubbed_token
    end

    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return(stubbed_token)
      user.generate_authentication_token!
      expect(user.auth_token).to eql stubbed_token
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: stubbed_token)
      user.generate_authentication_token!
      expect(user.auth_token).not_to eql existing_user.auth_token
    end
  end
end
