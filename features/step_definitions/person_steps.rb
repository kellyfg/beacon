Given(/^a resident$/) do
  @contact = Contact.create!(first_name: 'Test')
end

Given(/^a resident with a complete profile$/) do
  @contact = Contact.create!(first_name: 'Forename',
                             surname: 'Surname',
                             date_of_birth: Date.new(1982, 7, 1),
                             postcode: 'AB12 9YZ',
                             nhs_number: 'NHS-999999')
end

Given(/^a unique resident$/) do
  @contact = Contact.create!(first_name: 'Test' + rand(10**10).to_s(36))
end

Given(/^I am on a call with a resident$/) do
  @contact = Contact.create!(first_name: 'Test')
end

Given(/^I am editing the residents profile$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
end

Given(/^I am conducting a triage of the residents needs$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Add Needs'
end

When('I edit the special delivery details {string}') do |details|
  fill_in('contact_delivery_details', with: details)
end

When('I edit the dietary details to {string}') do |details|
  fill_in('contact_dietary_details', with: details)
end

When('I edit the total number of people to {string}') do |count|
  fill_in('contact_count_people_in_house', with: count)
end

When(/^I edit the residents name$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_first_name', with: 'TestFirstName')
  fill_in('contact_middle_names', with: 'TestMiddle Names')
  fill_in('contact_surname', with: 'TestSurname')
end

When("I change someone a resident's name concurrently") do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_first_name', with: 'TestFirstName1')

  user_two_updates_residents_name
  click_button('Save changes')
end

When("someone else updates the resident's name") do
  user_two_updates_residents_name
end

Then('I see my resident change was unsuccessful') do
  page.find('.alert', text: 'Error. Somebody else has changed this record, please refresh.')
  visit "contacts/#{@contact.id}"
  expect(page.find_by_id('contact_name')).to have_text('TestFirstName2')
end

def user_two_updates_residents_name
  Capybara.using_session('Second_users_session') do
    visit "contacts/#{@contact.id}"
    click_link 'Edit'
    fill_in('contact_first_name', with: 'TestFirstName2')
    click_button('Save changes')
  end
end

Then('I am informed another user has changed the record') do
  # this is the javascript / web socket message
  expect(page.find('#concurrent-users')).to have_text('This record is out of date')
end

When(/^I edit the residents address$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_address', with: 'Test Address')
  fill_in('contact_postcode', with: 'TE5 7PC')
end

When(/^I edit the residents contact details$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_email', with: 'test@test.com')
  fill_in('contact_telephone', with: '01 811 8055')
  fill_in('contact_mobile', with: '0770 123 456')
end

When(/^I edit the residents vulnerability status$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  find('label[for=is_vulnerable_true]').click
end

When(/^I edit the residents covid-19 status$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  find('label[for=has_covid_symptoms_true]').click
end

When('I choose {string} for any children under 15') do |option|
  if option == 'Yes'
    check 'contact_any_children_below_15'
  else
    uncheck 'contact_any_children_below_15'
  end
end

When('I choose {string} to eligible for free prescriptions') do |option|
  if option == 'Yes'
    choose 'eligible_for_free_prescriptions_true', allow_label_click: true
  else
    choose 'eligible_for_free_prescriptions_false', allow_label_click: true
  end
end

When('I choose {string} to any dietary requirements') do |option|
  if option == 'Yes'
    choose 'any_dietary_requirements_true', allow_label_click: true
  else
    choose 'any_dietary_requirements_false', allow_label_click: true
  end
end

When(/^I edit the residents additional info$/) do
  visit "contacts/#{@contact.id}"
  click_link 'Edit'
  fill_in('contact_additional_info', with: 'Test additional info')
end

When(/^I save the edit resident form$/) do
  click_button('Save changes')
end

Then('the residents list of support actions contains {string}') do |support_action|
  visit "/contacts/#{@contact.id}" unless @contact.nil?
  expect(page.first('.needs-table')).to have_text(support_action)
end

Then(/^I see a resident updated message$/) do
  expect(page.find('.notice')).to have_text('Contact was successfully updated.')
end

Then('the special delivery details are {string}') do |details|
  expect(page.find_by_id('delivery_details')).to have_text(details)
end

Then('the dietary details is {string}') do |details|
  expect(page.find_by_id('dietary_details')).to have_text(details)
end

Then('the children under 15 details are {string}') do |details|
  expect(page.find_by_id('any_children_below_15')).to have_text(details)
end

Then('eligible for free prescriptions is {string}') do |details|
  expect(page.find_by_id('eligible_for_free_prescriptions')).to have_text(details)
end

Then('the dietary requirements is {string}') do |details|
  expect(page.find_by_id('any_dietary_requirements')).to have_text(details)
end

Then('the total number of people is {string}') do |count|
  expect(page.find_by_id('count_people_in_house')).to have_text(count)
end

Then(/^the residents names have been updated$/) do
  expect(page.find_by_id('contact_name')).to have_text('TestFirstName TestMiddle Names TestSurname')
end

Then(/^the residents address has been updated$/) do
  expect(page.find_by_id('address_details')).to have_text('Test Address')
  expect(page.find_by_id('address_details')).to have_text('TE5 7PC')
end

Then(/^the residents contact details have been updated$/) do
  expect(page.find_by_id('email_address')).to have_text('test@test.com')
  expect(page.find_by_id('phone_details')).to have_text('01 811 8055')
  expect(page.find_by_id('phone_details')).to have_text('0770 123 456')
end

Then(/^the residents vulnerability status has been updated$/) do
  expect(page.find('.vulnerable-banner')).to have_text('This is a shielded person')
end

Then(/^the residents additional info has been updated$/) do
  expect(page.find_by_id('additional_info')).to have_text('Test additional info')
end

Then(/^the residents covid-19 status has been updated$/) do
  expect(page.find_by_id('contact-has-covid')).to have_text('Yes')
end

When('I search for the resident by {string}') do |query|
  visit 'contacts'
  fill_in('search', with: query)
  click_button('search-submit')
end

Then(/^I see the resident in the search results$/) do
  expect(page.find_link('Forename Surname')).not_to be_nil
  results_table = page.find('.table')
  expect(results_table).to have_text('Forename Surname')
  expect(results_table).to have_text('1982')
  expect(results_table).to have_text('AB12 9YZ')
  expect(results_table).to have_text('NHS-999999')
end

Then('I see an option to add a person') do
  expect(page.find_link('Add a person')).not_to be_nil
end

Then('I see a {string} message') do |message|
  expect(page.find('.no-results')).to have_text(message)
end
