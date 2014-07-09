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
  end
end

