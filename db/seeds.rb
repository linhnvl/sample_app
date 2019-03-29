User.create!(
  name: "Linh",
  email: "nguyenvanlinh12d3@gmail.com",
  password: "asdasd",
  password_confirmation: "asdasd",
  admin: true
)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end
