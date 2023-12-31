require 'rails_helper'

describe 'User sees room details' do
  it 'if authenticated' do
    visit root_path
    within('header nav') do
      click_on 'Sign in'
    end

    expect(current_path).to eq(new_user_session_path)
  end

  it 'successfully' do
    host = User.create!(email: 'host@email.com', password: '123456')

    full_address = FullAddress.create!(address: 'Av Atlântica', number: 500, neighborhood: 'Copacabana',
                                        city: 'Rio de Janeiro', state: 'RJ', zip_code: '12012-001')

    pm1 = PaymentMethod.create!(name: 'Dinheiro')
    pm2 = PaymentMethod.create!(name: 'Débito')
    payment_methods = [pm1, pm2]

    guesthouse = Guesthouse.create!(brand_name: 'Pousada Hilton', corporate_name: 'Hilton Corporate',
                                    register_number: '123456789', phone_number: '98765-4321',
                                    email: 'hilton@hilton.com', full_address: full_address,
                                    description: 'Em frente a orla', payment_methods: payment_methods,
                                    pet_friendly: 'Sim', terms: 'Proibido fumar', check_in_time: '8:00',
                                    check_out_time: '9:00', status: 'ativa', user: host)

    am1 = Amenity.create!(name: 'Varanda')
    am2 = Amenity.create!(name: 'TV')
    amenities = [am1, am2]

    room = Room.create!(name: 'Paris Hilton', maximum_guests: 3, description: '1 cama de casal e 1 de solteiro',
                        dimension: '10 m2', daily_price: '100', status: 'Disponível',
                        amenities: amenities, guesthouse: guesthouse)

    CustomPrice.create!(daily_price: '150', start_date: '2023-12-20', end_date: '2024-02-20', room: room)
    CustomPrice.create!(daily_price: '60', start_date: '2024-03-01', end_date: '2024-06-30', room: room)

    login_as(host)
    visit root_path
    click_on 'My Guesthouse'
    click_on 'Paris Hilton'

    expect(page).to have_content('Paris Hilton')
    expect(page).to have_content('Custom Prices')
    expect(page).to have_content('De 2023-12-20 até 2024-02-20')
    expect(page).to have_content('$150')
    expect(page).to have_content('De 2024-03-01 até 2024-06-30')
    expect(page).to have_content('$60')
  end

  it 'and there is no custom price' do
    host = User.create!(email: 'host@email.com', password: '123456')

    full_address = FullAddress.create!(address: 'Av Atlântica', number: 500, neighborhood: 'Copacabana',
                                        city: 'Rio de Janeiro', state: 'RJ', zip_code: '12012-001')

    pm1 = PaymentMethod.create!(name: 'Dinheiro')
    pm2 = PaymentMethod.create!(name: 'Débito')
    payment_methods = [pm1, pm2]

    guesthouse = Guesthouse.create!(brand_name: 'Pousada Hilton', corporate_name: 'Hilton Corporate',
                                    register_number: '123456789', phone_number: '98765-4321',
                                    email: 'hilton@hilton.com', full_address: full_address,
                                    description: 'Em frente a orla', payment_methods: payment_methods,
                                    pet_friendly: 'Sim', terms: 'Proibido fumar', check_in_time: '8:00',
                                    check_out_time: '9:00', status: 'ativa', user: host)

    am1 = Amenity.create!(name: 'Varanda')
    am2 = Amenity.create!(name: 'TV')
    amenities = [am1, am2]

    room = Room.create!(name: 'Paris Hilton', maximum_guests: 3, description: '1 cama de casal e 1 de solteiro',
                        dimension: '10 m2', daily_price: '100', status: 'Disponível',
                        amenities: amenities, guesthouse: guesthouse)

    login_as(host)
    visit root_path
    click_on 'My Guesthouse'
    click_on 'Paris Hilton'

    expect(page).to have_content('There is no custom price')
    expect(page).not_to have_content('De 2024-03-01 até 2024-06-30')
    expect(page).not_to have_content('$60')
  end
end
