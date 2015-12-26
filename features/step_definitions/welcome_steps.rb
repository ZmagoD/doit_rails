Given(/^I am on the home page$/) do
  visit root_path
end

Then(/^I should see "(.*?)"$/) do |arg1|
  expect(page).to have_content("Volunteer opportunities")
end

Then(/^I should see a pin on the map$/) do
  expect(page).to have_selector('#markers img', count: 1)
end