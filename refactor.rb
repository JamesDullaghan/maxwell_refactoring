# Controller
# extract to controllers/peoples_controller.rb

class People < ActionController::Base

	# ... Other REST actions

	def create
		@person = Person.new(params[:person])

		slug = "ABC123#{Time.now.to_i.to_s}1239827#{rand(10000)}"
		@person.slug = slug
		@person.admin = false

		if (Person.count + 1).odd?
			team = "UnicornRainbows"
			handle = "UnicornRainbows" + (Person.count + 1).to_s
			@person.handle = handle
			@person.team = team
		else
			team = "LaserScorpions"
			handle = "LaserScorpions" + (Person.count + 1).to_s
			@person.handle = handle
			@person.team = team
		end

		if @person.save
			Emails.validate_email(@person).deliver
			@admins = Person.where(:admin => true)
			Emails.admin_new_user(@admins, @person).deliver
			redirect_to @person, :notice => "Account added!"
		else
			render :new
		end
	end

	# How is this used? There is no response, just mail delivery
	# Is it a put or post from ajax, or a rails form?
	def validateEmail
		@user = Person.find_by_slug(params[:slug])
		if @user.present?
			@user.validated = true
			@user.save
			Rails.logger.info "USER: User ##{@person.id} validated email successfully."
			@admins = Person.where(:admin => true)
			Emails.admin_user_validated(@admins, user)
			Emails.welcome(@user).deliver!
		end
	end

end


# Model
# extracted to models/person.rb
class Person < ActiveRecord::Base

	attr_accessible :first_name,
									:last_name,
									:email,
									:admin,
									:slug,
									:validated,
									:handle,
									:team
end


# Mailer
# extract to mailers/emails.rb

class Emails < ActionMailer::Base

	def welcome(person)
		@person = person
		mail to: @person, from: 'foo@example.com'
	end

	def validate_email(person)
		@person = person
		mail to: @person, from: 'foo@example.com'
	end

	def admin_user_validated(admins, user)
		@admins = admins.collect {|a| a.email } rescue []
		@user = user
		mail to: @admins, from: 'foo@example.com'
	end

	def admin_new_user(admins, user)
		@admins = admins.collect {|a| a.email } rescue []
		@user = user
		mail to: @admins, from: 'foo@example.com'
	end

	def admin_removing_unvalidated_users(admins, users)
		@admins = admins.collect {|a| a.email } rescue []
		@users = users
		mail to: admins, from: 'foo@example.com'
	end

end


# Rake Task
# extract to lib/tasks/accounts.rake
namespace :accounts do

	desc "Remove accounts where the email was never validated and it is over 30 days old"
	task :remove_unvalidated do
		ActiveRecord::Base.transaction do
			people = Person.unvalidated
			people.each do |person|
				Rails.logger.info "Removing unvalidated user #{person.email}"
				person.destroy
			end
			Emails.admin_removing_unvalidated_users(Person.admins, people).deliver
		end
		@people = Person.unvalidated
		@people.each do |person|
			Rails.logger.info "Removing unvalidated user #{person.email}"
			person.destroy
		end
		Emails.admin_removing_unvalidated_users(Person.where(:admin => true), @people).deliver
	end

end
