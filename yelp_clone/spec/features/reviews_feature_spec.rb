require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create name: 'KFC' }

  before do
    visit '/restaurants'
    click_link 'Sign up'
    fill_in 'Email', with: "will@will.will"
    fill_in 'Password', with: "will123"
    fill_in 'Password confirmation', with: "will123"
    click_button 'Sign up'
  end

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'

     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end
end
