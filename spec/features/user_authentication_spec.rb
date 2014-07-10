require "spec_helper"

feature "See Homepage" do
  scenario "A anonymous user can see the register button on homepage" do

    #"An anonyous user can click registration button & see registration form"
    visit "/"
    click_link "Register"
    fill_in "username", with: "User"
    fill_in "password", with: "Password"
    click_button "Register"
    page.has_content?('Thanks for registering!')

    #"If we don't fill in form, we get an error" do
    visit "/register"
    fill_in "username", with: ""
    fill_in "password", with: ""
    page.has_content?('fill in')

    #"If we try to register a name that's already taken, we get an error" do
    visit "/register"
    fill_in "username", with: "User"
    fill_in "password", with: "Password"
    page.has_content?('taken')

    #scenario "User can sort names" do
    visit "/"
    click_link "Register"
    fill_in "username", with: "z"
    fill_in "password", with: "z"
    click_button "Register"
    visit "/register"
    fill_in "username", with: "a"
    fill_in "password", with: "a"
    click_button "Register"
    visit "/"

    #can login
    fill_in "username", with: "User"
    fill_in "password", with: "Password"
    click_button "Sign In"

    #sees logged-in homepage
    page.has_content?("User", count: 1)
    page.has_content?("Welcome, User")
    page.has_content?("z")

    #can alphabetize userlist
    click_button "Alphabetize"
    page.should have_selector("ul li:nth-child(1)", :text => "a")

    #can delete users
    fill_in "username_to_delete", with: "z"
    click_button "Delete User"
    page.has_content?("z") == false

    fill_in "username_to_delete", with: "a"
    click_button "Delete User"
    page.has_content?("a") == false

    fill_in "username_to_delete", with: "user"
    click_button "Delete User"
    page.has_content?("user") == false

    #scenario "I can log out of homepage" do

    click_button "Log Out"
    page.has_content?("Sign In")
  end

  #database_cleaner
end

