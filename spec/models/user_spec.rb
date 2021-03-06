require 'rails_helper'

RSpec.describe User, type: :model do

  let(:subject) { build(:user) }
  let(:following_subject) { FactoryGirl.create(:following_user) }

  describe "test suit" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:user)).to be_valid
    end
  end

  describe "direct associations" do
    it "has many authored posts" do
      t = User.reflect_on_association(:authored_posts)
      expect(t.macro).to eq(:has_many)
    end 
    it "has many likes" do
      t = User.reflect_on_association(:likes)
      expect(t.macro).to eq(:has_many)
    end 
    it "has many & belongs to many posts" do
      t = User.reflect_on_association(:posts)
      expect(t.macro).to eq(:has_and_belongs_to_many)
    end 
  end

  describe "through associations" do
    it "has many followers" do
      subject = create(:user)
      follower = create(:wonderwoman)
      subject.followers << follower
      expect(subject.followers.first).to eq(follower)
    end

    it "has many followed" do
      subject  = create(:user)
      leader   = create(:wonderwoman)
      subject.followed << leader
      expect(subject.followed.first).to eq(leader)
    end
  end

  describe "password" do
    it "encrypts password in db" do
      expect(subject.password_hash).to_not eq("joker")
    end
    it "recognizes password on authentication" do
      expect(subject.authentic_password?("joker")).to be true
    end
    it "resets to scrambled password on reset" do
      random_pw = subject.change_to_random_password
      expect(subject.authentic_password?(random_pw)).to be true
    end
  end
end
