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
  page.has_content?("User", count: 1)
  page.has_content?("Username")


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

feature "Registration errors" do
  scenario "If we try to register a name that's already taken, we get an error" do
    visit "/register"
    fill_in "username", with: "User"
    fill_in "password", with: "Password"
    page.has_content?('taken')
  end
end

feature "Registration not filled in error" do
  scenario "If we don't fill in form, we get an error" do
    visit "/register"
    fill_in "username", with: ""
    fill_in "password", with: ""
    page.has_content?('fill in')
  end
end

  feature "Order names" do
    scenario "User can sort names" do
      visit "/"
      click_link "Register"
        fill_in "username", with: "z"
        fill_in "password", with: "z"
        click_button "Register"
      visit "/register"
      fill_in "username", with: "a"
      fill_in "password", with: "a"
      click_button "Register"
      fill_in "username", with: "User"
      fill_in "password", with: "Password"
      visit "/"
      click_button "Sign In"
      click_button "Alphabetize"
      page.should have_tag("ul:last-child", :text => "z")

    end
end

end