class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  ROLES = %i[superadmin admin user]
  acts_as_voter
  before_create :set_default_role

  private
  def set_default_role
    self.role = 'user'
  end
  # attr_accessor :terms_and_conditions
  # validates_acceptance_of :terms_and_conditions, :allow_nil => false, :message => ""
end
