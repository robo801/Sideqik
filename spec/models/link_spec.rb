require 'rails_helper'
TEST_URL = 'https://testing.com'

RSpec.describe Link, type: :model do
  it 'can not create a link without url' do 
   new_link = Link.create()
   expect(new_link.valid?).to eq false
   expect(new_link.errors[:user]).to include('must exist')
   expect(new_link.errors[:url]).to include("can't be blank") 
  end

  it 'throws an error when url is not passed' do
    user = User.find_by(username: 'test1')
    created_link = Link.create(user_id: user.id)
    expect(created_link.errors[:url]).to include("can't be blank")
  end

  it 'creates a shortened link for a url' do
    user = User.find_by(username: 'test1')
    created_link = Link.create(user_id: user.id, url:TEST_URL)
    expect(created_link.valid?).to eq true
    expect(created_link.user_id).to eq user.id
    expect(created_link.url).to eq TEST_URL
    expect(created_link.short_link).to_not eq nil
  end
end
