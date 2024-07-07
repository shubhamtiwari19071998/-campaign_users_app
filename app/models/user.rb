class User < ApplicationRecord
  validates :name, presence: { message: "can't be blank" }
  validates :email, presence: { message: "can't be blank" }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }
end
