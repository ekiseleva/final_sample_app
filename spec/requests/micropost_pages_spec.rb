require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "signed in other user" do
      let(:first_user) { FactoryGirl.create(:user) }
      let(:second_user) { FactoryGirl.create(:user) }
      before do
        sign_in second_user
        visit user_path(first_user)
      end

      describe "not have delete links" do
        it { should_not have_link('delete') }
      end
    end


    describe "pagination" do
      it "should paginate the feed" do
        31.times { FactoryGirl.create(:micropost, user: user, content: "Consectetur adipiscing elit") }
        visit root_path
        page.should have_selector("div.pagination")
      end
    end

    describe "sidebar micropost count" do
      it "has counts for micropost" do
        expect { current_user.microposts.count }
      end
    end

    describe "sidebard micropost's word" do
      it "to be pluralized" do
        expect { pluralize(current_user.microposts.count, "micropost") }
      end
    end

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end