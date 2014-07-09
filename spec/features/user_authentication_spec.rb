require "spec_helper"

feature "See Homepage" do
  scenario "A anonymous user can see the register button on homepage" do
  visit "/"
  click_link "Register"
  end
end

feature "Registration" do
  scenario "An anonyous user can click registration button & see registration form" do
    visit "/"
    click_link "Register"
    fill_in "username", with: "User"
    fill_in "password", with: "Password"
    click_button "Register"
    page.has_content?('Thanks for registering!')
  end
end

feature "Login" do
  scenario "I can log into the homepage" do
  visit "/"
  fill_in "username", with: "User"
  fill_in "password", with: "Password"
  click_button "Sign In"
  page.has_content?("Welcome, User")

end

feature "Logout" do
  scenario "I can log out of homepage" do
    visit "/"
    fill_in "username", with: "User"
    fill_in "password", with: "Password"
    click_button "Sign In"
    click_button "Log Out"
    page.has_content?("Sign In")
  end
end


end