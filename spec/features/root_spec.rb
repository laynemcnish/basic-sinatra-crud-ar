require "spec_helper"

feature "homepage" do
  scenario "should have a registration button" do
    visit "/"

    expect(page).to have_button("Register")
  end
end

feature "register" do
  scenario "should have registration form, and then be able to login" do
    i_am_registered
    expect(page).to have_content('Thank you for registering')
  end
end


feature "login" do
  scenario "should let the user login" do
    i_am_registered
    i_am_logged_in
    expect(page).to have_content('Welcome, user1!')
  end
end

feature "see users list" do
  scenario "should see a list of users when logged in" do
    i_am_registered
    i_am_logged_in
    expect(page).to have_content('zeta')
    expect(page).to have_content('user1', count: 1)
  end
end


feature "able to alphabetize users" do
  scenario "should see an order menu and button" do
    i_am_registered
    i_am_logged_in
    expect(page).to have_button("Order")
    click_button ("Order")
  end
end

feature "able to delete a user" do
  scenario "should be able to enter username and click delete" do
    i_am_registered
    i_am_logged_in
    click_link('Delete')
    expect(page).to_not have_content('zeta')

  end
end

feature "able to create a fish" do
  scenario "user should be able to enter a fish name and wikipage" do
    i_am_registered
    i_am_logged_in
    visit("/add_fish")
    fill_in('fish_name', :with => 'blowfish')
    fill_in('wikipage', :with => 'http://en.wikipedia.org/wiki/Blowfish_(cipher)')
    click_button 'Add Fish'
    expect(page).to have_content('blowfish')

  end
end

def i_am_registered
  visit "/register"
  fill_in('username', :with => 'user1')
  fill_in('password', :with => 'password')
  click_button 'Register'

  click_button 'Register'
  fill_in('username', :with => 'zeta')
  fill_in('password', :with => 'password')
  click_button 'Register'

  click_button 'Register'
  fill_in('username', :with => 'beta')
  fill_in('password', :with => 'password')
  click_button 'Register'
end

def i_am_logged_in
  i_am_registered
  visit "/"
  fill_in('username', :with => 'user1')
  fill_in('password', :with => 'password')
  click_button 'Login'
end