require "spec_helper"

feature "See Homepage" do
  scenario "A anonymous user can see the register button on homepage" do
  visit "/"
  click_button "Register"
  end
end

