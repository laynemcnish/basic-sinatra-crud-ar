require "spec_helper"

feature "See Homepage" do
  scenario "A anonymous user can see the register button on homepage" do

    visit "/"
    expect(page).to have_button("Register")
  end
end

feature "Register" do
  scenario "An anonymous user can register" do
    register_with_multiple_names
    expect(page).to have_content('Thanks for registering!')
  end
end

feature "Registration Errors" do
  scenario "If an anyonymous user doesn't fill in the complete form, they get an error" do
    visit "/register"
    fill_in "username", with: ""
    fill_in "password", with: ""
    click_button "Register"
    expect(page).to have_content('Please fill in all fields.')
  end

  scenario "If we try to register a name that's already taken, we get an error" do
    register_with_multiple_names
    visit "/register"
    fill_in "username", with: "blah"
    fill_in "password", with: "blah"
    click_button "Register"
    expect(page).to have_content('Username is already taken.')
  end
end

feature "User can login" do
  scenario "Once logged in, they should see a welcome message" do
    register_with_multiple_names
    login_with_username_blah
    expect(page).to have_content("Welcome, blah")
  end
end

feature "user can see list of names" do
  scenario "once logged in, a user can see a list of other users" do
    register_with_multiple_names
    login_with_username_blah
    expect(page).to have_content('zeta')
    expect(page).to have_content('blah', count: 1)
  end
end

feature "alphabetize" do
  scenario "once logged in, a user can alphabetize list of users" do
  register_with_multiple_names
  login_with_username_blah
  click_button "Order"
  expect(page).to have_selector("ul li:nth-child(1)", :text => "alpha")
  end
end

feature "delete user" do
  scenario "logged in users can delete other users" do
    register_with_multiple_names
    login_with_username_blah
    fill_in "username_to_delete", with: "zeta"
    click_button "Delete User"
    expect(page).to_not have_content("zeta")
  end
end

feature "create fish" do
  scenario "users can create fish" do
    register_with_multiple_names
    login_with_username_blah
    fill_in "fishname", with: "Goldfish"
    fill_in "fishwiki", with: "http://en.wikipedia.org/wiki/Goldfish"
    click_button "Make Fish"
    expect(page).to have_link("Goldfish", options={href: "http://en.wikipedia.org/wiki/Goldfish"})
    expect(page).to_not have_link("Bass")
  end
end

feature "Log Out" do
  scenario "user can log out and again be an anyonymous user" do
    register_with_multiple_names
    login_with_username_blah
    click_button "Log Out"
    expect(page).to have_content("Sign In")
  end
end

feature "fish list" do
  scenario "Logged in users can see other users fish when they click on their names" do
    register_with_multiple_names
    login_with_username_blah
    fill_in "fishname", with: "Trout"
    fill_in "fishwiki", with: "http://en.wikipedia.org/wiki/Goldfish"
    click_button "Make Fish"
    click_button "Log Out"
    fill_in "username", with: "alpha"
    fill_in "password", with: "alpha"
    click_button "Sign In"

    click_link "blah"
    expect(page).to have_link "Trout"

  end
end



def register_with_multiple_names
  visit "/register"
  fill_in "username", with: "blah"
  fill_in "password", with: "blah"
  click_button "Register"

  click_button "Register"
  fill_in "username", with: "zeta"
  fill_in "password", with: "zeta"
  click_button "Register"

  click_button "Register"
  fill_in "username", with: "alpha"
  fill_in "password", with: "alpha"
  click_button "Register"
end

def login_with_username_blah
  register_with_multiple_names
  visit "/"
  fill_in "username", with: "blah"
  fill_in "password", with: "blah"
  click_button "Sign In"
end