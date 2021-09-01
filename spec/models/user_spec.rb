require 'rails_helper'
NAME_1 = 'random name'
PASSWORD_1 = 'password'

RSpec.describe User, type: :model do

  it 'testing seeding users' do
    users = User.all
    expect(users.count).to eq 2
  end

  it 'needs username to create a user' do
    new_user = User.create
    expect(new_user.valid?).to eq false
  end

  it 'needs password to create a user' do
    new_user = User.create({username: NAME_1, password: ''})
    expect(new_user.valid?).to eq false
  end

  it 'can succesfully create a new user' do
    new_user = User.create(username: NAME_1, password: PASSWORD_1)
    expect(new_user.valid?).to eq true
    expect(new_user.username).to eq NAME_1
  end

  it 'can not create a user with same username' do
    new_user = User.create(username: 'test1', password: PASSWORD_1)
    expect(new_user.valid?).to eq false
  end

  it 'can not create / update a user with same token' do
    new_user = User.create(username: NAME_1, password: PASSWORD_1, token: 'token')
    expect(new_user.valid?).to eq false
    new_user = User.create(username: NAME_1, password: PASSWORD_1, token: 'token_new')
    expect(new_user.valid?).to eq true
    new_user.update(token: 'token')
    expect(new_user.valid?).to eq false
  end

  it 'validates password is encrypted before storing' do
    new_user = User.create(username: NAME_1, password: PASSWORD_1)
    expect(new_user.valid?).to eq true
    expect(new_user.authenticate(PASSWORD_1)).to_not eq false 
  end

  it 'generates an oauth token for a user' do
	new_user = User.create(username: NAME_1, password: PASSWORD_1)
	expect(new_user.valid?).to eq true
	expect(new_user.token).to be nil
        new_user.generate_token
        expect(new_user.token).to_not be nil
  end

end
