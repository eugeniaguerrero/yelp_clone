require 'rails_helper'

feature 'restaurants' do

  before do
    sign_up
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do

    before do
      create_restaurant
      sign_out
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      create_restaurant
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        create_restaurant(name: 'kf')
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do

    before do
      create_restaurant
      sign_out
    end

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
    end
  end

  context 'editing restaurants' do


    scenario 'let a user edit a restaurant' do
      create_restaurant
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      click_link 'Kentucky Fried Chicken'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
    end

  end

  context 'deleting restaurants' do

    scenario 'removes a restaurant when a user clicks a delete link' do
      create_restaurant
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).to have_content 'KFC deleted successfully'
    end

  end

  context 'user permissions' do

    before do
      create_restaurant
      sign_out
      sign_up(email: 'test2@example.com',password: 'testtest2')
    end

    scenario 'user cannot edit restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content "Cannot Edit a Restaurant you don't own"
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user cannot delete restaurant' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).to have_content "Cannot Delete a Restaurant you don't own"
      expect(current_path).to eq '/restaurants'
    end

  end

end
