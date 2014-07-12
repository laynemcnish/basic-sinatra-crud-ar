require "spec_helper"

feature "See Homepage" do
  scenario "A anonymous user can see the register button on homepage" do

    #"An anonyous user can click registration button & see registration form"
    visit "/"
    click_button ("Register")
    fill_in "username", with: "blah"
    fill_in "password", with: "blah"
    click_button "Register"
    expect(page).to have_content('Thanks for registering!')

    #"If we don't fill in form, we get an error" do
    visit "/register"
    fill_in "username", with: ""
    fill_in "password", with: ""
    click_button "Register"
    expect(page).to have_content('Please fill in all fields.')

    #"If we try to register a name that's already taken, we get an error" do
    visit "/register"
    fill_in "username", with: "blah"
    fill_in "password", with: "blah"
    click_button "Register"
    expect(page).to have_content('Username is already taken.')

    #scenario "User can sort names" do
    visit "/"
    click_button "Register"
    fill_in "username", with: "zeta"
    fill_in "password", with: "zeta"
    click_button "Register"

    click_button "Register"
    fill_in "username", with: "alpha"
    fill_in "password", with: "alpha"
    click_button "Register"
    visit "/"

    #can login
    fill_in "username", with: "blah"
    fill_in "password", with: "blah"
    click_button "Sign In"

    #sees logged-in homepage
    # expect(page).to have_content("blah", count: 1)
    expect(page).to have_content("Welcome, blah")
    expect(page).to have_content("zeta")

    #can alphabetize userlist
    click_button "Order"
    expect(page).to have_selector("ul li:nth-child(1)", :text => "alpha")

    #can delete users
    fill_in "username_to_delete", with: "zeta"
    click_button "Delete User"
    expect(page).to_not have_content("zeta")

    #user can create a fish
    fill_in "fishname", with: "Goldfish"
    fill_in "fishwiki", with: "http://en.wikipedia.org/wiki/Goldfish"
    click_button "Make Fish"
    expect(page).to have_link("Goldfish", options={href:"http://en.wikipedia.org/wiki/Goldfish"})
    expect(page).to_not have_link("Bass")

    #scenario "I can log out of homepage" do

    click_button "Log Out"
    expect(page).to have_content("Sign In")

    #scenario "I can see other users fish when I click on their names"

    fill_in "username", with: "alpha"
    fill_in "password", with: "alpha"
    click_button "Sign In"
    fill_in "fishname", with: "Trout"
    fill_in "fishwiki", with: "http://en.wikipedia.org/wiki/Goldfish"
    click_button "Make Fish"
    click_link "blah"
    expect(page).to have_link "Goldfish"
    expect(page).to have_link "Trout"
    expect(page).to have_content "Goldfish"
  end

  #database_cleaner
end

