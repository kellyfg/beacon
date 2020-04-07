Given(/^I am logged into the system$/) do
  visit generate_magic_link
  expect(page.status_code).to eq(200)
  expect(page).to have_content('People in need')
end

def generate_magic_link
  tester = User.create!(email: 'test@test.com', invited: Date.today)
  session = Passwordless::Session.new({
                                          authenticatable: tester,
                                          user_agent: 'Cucumber-tests',
                                          remote_addr: 'unknown',
                                      })
  session.save!
  magic_link = send(Passwordless.mounted_as).token_sign_in_url(session.token)
  "/sign_in/#{magic_link.split('/').last}"
end