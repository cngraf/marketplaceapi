require 'spec_helper'

describe Api::V1::SessionsController do

	describe "POST #create" do
    let(:user) { FactoryGirl.create(:user) }

    context 'with valid credentials' do
      let(:credentials) { { email: user.email, password: '12345678' } }

      before do
        post :create, { session: credentials }
      end

      it 'returns the correct user record' do
        user.reload
        expect(json_response[:auth_token]).to eql user.auth_token
      end

      it { should respond_with(200) }
    end

    context 'with invalid credentials' do
      let(:credentials) { { email: user.email, password: 'bumblebees' } }

      before do
        post :create, { session: credentials }
      end

      it 'returns a json thing wiht some error' do
        expect(json_response[:errors].empty?).to be_false
      end

      it { should respond_with(422) }
    end
	end

end
