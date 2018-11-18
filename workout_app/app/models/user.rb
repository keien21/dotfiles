class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # nameカラムに関するバリデーションを作成してください
  #validates :name, {presence: true}

  # emailカラムに関するバリデーションを作成してください
  #validates :email, {presence: true, uniqueness: true}

end
