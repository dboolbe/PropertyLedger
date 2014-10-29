# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.all.each do |user|
  10.times do ||
    Property.create user: user,
                    nickname: Faker::Company.name,
                    description: Faker::Company.bs,
                    address: "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.state} #{Faker::Address.zip_code}"
  end

  user.properties.each do |property|
    (rand 11).times do ||
      Transaction.create property: property,
                         account: Faker::Company.name,
                         date: Faker::Date.birthday,
                         income: Faker::Commerce.price,
                         expense: Faker::Commerce.price,
                         miscellaneous: Faker::Commerce.price,
                         comment: Faker::Company.bs
    end
  end
end
