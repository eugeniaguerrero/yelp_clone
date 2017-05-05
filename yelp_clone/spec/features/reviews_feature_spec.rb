require 'rails_helper'

feature 'reviewing' do

  before do
    sign_up
    create_restaurant
    review_restaurant
  end

  scenario 'allows users to leave a review using a form' do
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'can own delete review' do
    expect(page).to have_content("so so")
    click_link 'Delete review'
    expect(page).not_to have_content("so so")
  end

  scenario "can't delete someone elses review" do
    sign_out
    sign_up(email: 'test2@example.com')
    expect(page).not_to have_content("Delete review")
  end
end
