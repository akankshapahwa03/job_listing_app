
desc "create_admin"
task create_admin: :environment do
  puts "Enter name"
  name = $stdin.gets.chomp
  puts "Enter email"
  email = $stdin.gets.chomp
  password = '12345678'
  user = User.new(name: name, email: email, password: password, role: :admin)
  if user.save
    puts("Admin created successfully")
    puts("Your password is #{password}")
  else
    puts "Failed to create admin. 
    Errors: #{user.errors.full_messages.join(', ')}"
  end
end
