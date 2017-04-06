describe 'The Apprentice News submission page', type: :feature do

  it 'should allow the user to submit a story' do
    visit '/submit'
    expect(page).to have_text('Submit')
  end

end
