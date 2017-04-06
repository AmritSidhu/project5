describe 'The Apprentice News homepage', type: :feature do

  it 'should have a heading' do
    visit '/'
    expect(page).to have_text('Apprentice News')
  end

  it 'should have a list of submissions' do
    visit '/'
    expect(page).to have_link('https://www.gov.uk')
  end

  it 'should sort submissions newest first' do
    visit '/'
    expect(page).to have_link('https://www.codewars.com/users/JonathanHallam')
    expect(page).to have_link('https://www.gov.uk')
  end

end
