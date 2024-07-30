class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable
  enum role: %i[admin member]
end
