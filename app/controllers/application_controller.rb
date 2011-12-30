# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base

	protect_from_forgery
  
  def in_couple?(sender)
  	@user = User.find_by_phone_number(sender)
  	if @user.eql?(nil)
# user doesn't exists in the database
  		false
  	else
# user exists in the database
# but user is not in couple
			if @user.in_couple_with.eql?(nil)
				false
			else
# and user is in couple
  			true
  		end
  	end
  end
  
  def break_relationship?(sender, content)
# user wants to send a message
  	if /^#{Parameter.first.break_relationship}/i.match(content).eql?(nil)
  		false
  	else
# user wants to break relationship
			@swain = content.sub(/^#{Parameter.first.break_relationship}/i.match(content).to_s, '').strip #
			if (User.find_by_username(@swain).username).eql?(User.find_by_phone_number(sender).in_couple_with) #
				true #
			else #
				false #
			end #
  		#true
  	end
  end
  
  def clear_relationship(sender, sms_id, service_id)
# find both swains
  	@swain1 = User.find_by_phone_number(sender)
		@swain2 = User.find_by_username(@swain1.in_couple_with)
# clear relationship
		@relation = Relation.where("(user_id = #{@swain1.id} OR target = '#{@swain1.phone_number}') AND status = true")
		@relation.each do |relation|
  		relation.update_attributes(:broken_at => Time.now, :status => false)
		end
# clear both in_couple_with fields
		@swain1.update_attributes(:in_couple_with => nil)
		@swain2.update_attributes(:in_couple_with => nil)
		error_message(@swain2.phone_number, sms_id, service_id, "#{@swain1.username} vient de vous quitter. Pour rechercher quelqu'un d'autre, envoyez une tranche d'âge par exemple: 18 23")
  end
  
  def registration?(content)
  	if /^#{Parameter.first.registration}/i.match(content.strip).eql?(nil)
  		false
  	else
  		true
  	end
  end
  
  def already_registered?(sender)
  	if User.find_by_phone_number(sender).eql?(nil)
  		false
  	else
  		true
  	end
  end
  
  def profile_completed?(sender)
  	if User.find_by_phone_number(sender).gender.eql?(nil)
  		false
  	else
  		true
  	end
  end
  
  def already_registered(sender, sms_id, service_id)
  	@username = User.find_by_phone_number(sender).username  	
  	error_message(sender, sms_id, service_id, "Vous êtes déjà enregistré sous le nom de: #{@username}")
  end
  
  def register_user(sender, sms_id, service_id, content)
  	@age = ''
  	@username = ''
  	@gender = ''  	
  	content = content.sub(/#{Parameter.first.registration}/i, '').strip
		if /\b.+?\b/.match(content).eql?(nil)
			error_message(sender, sms_id, service_id, "Veuillez préciser votre pseudonyme. Exemple: #{Parameter.first.registration} votre_pseudo")
		else
			@username = /\b.+?\b/.match(content).to_s
			if @username.size < 4
				error_message(sender, sms_id, service_id, 'Votre pseudonyme doit faire plus de quatre caractères.')
			else
				if User.find_by_username(@username).eql?(nil)
					User.create(:username => @username, :phone_number => sender)
					error_message(sender, sms_id, service_id, "Félicitations, votre pseudonyme est: #{@username}. Veuillez le compléter en envoyant votre âge et votre sexe: h 23 ou f 25")
				else
# Suggestions list?
					error_message(sender, sms_id, service_id, "Ce pseudonyme est déjà utilisé veuillez en choisir un autre.")
				end
			end
		end
	end  
	
	def complete_profile(sender, sms_id, service_id, content)
		@age = ''
		@gender = ''
		if /\b[1-4][0-9]\b/.match(content).eql?(nil)
#send_message('Erreur concernant lage: mauvaise tranche, non donne ou typographie')
  		error_message(sender, sms_id, service_id, "Veuillez compléter votre profil en envoyant votre âge et votre sexe: h 23 ou f 25")  		
  	else
  		@age = /\b[1-4][0-9]\b/.match(content).to_s
  		content = content.sub(@age, '').strip
# get gender
			if (/\bf\b/i.match(content).eql?(nil) && /\bh\b/i.match(content).eql?(nil))
				error_message(sender, sms_id, service_id, "Veuillez compléter votre profil en envoyant votre âge et votre sexe: h 23 ou f 25")
			else
				@gender = get_gender(content)
				User.find_by_phone_number(sender).update_attributes(:gender => @gender, :age => @age.to_i)
				error_message(sender, sms_id, service_id, "Félicitations, votre profil a été complété.")
			end					 	
  	end
	end
		
  def get_gender(content)
  	if /\bf\b/i.match(content).eql?(nil)
  		/\bh\b/i.match(content).to_s
  	else
  		/\bf\b/i.match(content).to_s
  	end
  end

# the first word of the message is :zone  
  def update_area?(content, sender)  	
  	if /^#{Parameter.first.area}/i.match(content).eql?(nil)
  		false
  	else
  		true
  	end
  end
  
  def update_area(sender, sms_id, service_id, content)
  	content = content.sub(/#{Parameter.first.area}/i, '').strip
# get all characters after zone
  	if /\b.+\b/.match(content).eql?(nil)
  		error_message(sender, sms_id, service_id, "Vous n'avez pas entré de zone géographique. Exemple: #{Parameter.first.area} yopougon")
  	else
  		User.find_by_phone_number(sender).update_attributes(:area => content) 
  		error_message(sender, sms_id, service_id, "Votre zone géographique est maintenant: #{User.find_by_phone_number(sender).area}")
  	end  		
  end

# the first word of the message is info or infos  
  def infos?(content, sender)
  	if (/^info/i.match(content).eql?(nil) && /^#{Parameter.first.informations}/i.match(content).eql?(nil))
  		false
  	else
  		true
  	end
  end
 
  def get_infos?(content)
  	content = content.sub(/^#{Parameter.first.informations}/i, '').sub(/^info/i, '').strip
  	@username = /\b.+?\b/.match(content).to_s
  	if User.find_by_username(@username).eql?(nil)
  		false
  	else
  		true
  	end
  end

# a user wants to check another user infos   
  def get_infos(sender, sms_id, service_id, content)
  	content = content.sub(/^#{Parameter.first.informations}/i, '').sub(/^info/i, '').strip
  	@username = /\b.+?\b/.match(content).to_s
  	@infos = User.find_by_username(@username).infos
# send friendly message 
  	if @infos.eql?(nil)
  		error_message(sender, sms_id, service_id, "Cet utilisateur n'a pas entré d'information le concernant.")
  	else
  		error_message(sender, sms_id, service_id, "#{@username}: #{@infos}")
  	end
  	
  end

# a user wants to set his personal infos  
  def set_infos(sender, sms_id, service_id, content)
  	content = content.sub(/^#{Parameter.first.informations}/i, '').sub(/^info/i, '').strip
  	@user = User.find_by_phone_number(sender)
# regexp to detect spaces  	
  	if /\b.+?\b/.match(content).eql?(nil)
  		error_message(sender, sms_id, service_id, "Vous n'avez entré aucune information vous concernant. Exemple: #{Parameter.first.informations} étudiant à l'université")
  	else
# we store infos when there is no spaces
  		@user.update_attributes(:infos => /^[a-z 0-9]+$/.match(content).to_s)
  		error_message(sender, sms_id, service_id, " Félicitations, votre profil a été mis à jour.")
  	end
  end
  
  def initiate?(content)
  	if /^#{Parameter.first.initiate_relationship}/i.match(content).eql?(nil)
  		false
  	else
  		true
  	end
  end

#initiate relationship  
  def initiate(sender, sms_id, service_id, content)
  	content = content.sub(/^#{Parameter.first.initiate_relationship}/i, '').strip
  	@target = ''
  	@target_phone_number = ''
  	@sender = User.find_by_phone_number(sender)
# user didn't supply a target name'
  	if /\b.+?\b/.match(content).eql?(nil)
  		error_message(sender, sms_id, service_id, "Vous n'avez entré le nom d'aucune cible. Exemple: #{Parameter.first.initiate_relationship} christine")
  	else
  		@target = /\b.+?\b/.match(content).to_s  		
# username doesnt exists
  		if User.find_by_username(@target).eql?(nil)
  			error_message(sender, sms_id, service_id, "Cet utilisateur n'existe pas.")
  		else
				if User.find_by_username(@target).gender == @sender.gender
					error_message(sender, sms_id, service_id, "Vous ne pouvez vous mettre en couple qu'avec des utilisateurs du sexe opposé")
				else
# user is already in couple
					@target_phone_number = User.find_by_username(@target).phone_number
					if User.find_by_username(@target).in_couple_with.eql?(nil)
	# you already sent a demand to this user
						if Relation.where("user_id = #{@sender.id} AND target = '#{@target_phone_number}' AND created_at = updated_at").empty?
							@sender.relations.create(:target => @target_phone_number, :status => false)
							error_message(@target_phone_number, sms_id, service_id, "#{@sender.username} désire se mettre en couple avec vous. Pour accepter, envoyez #{Parameter.first.accept} ou #{Parameter.first.accept} #{@sender.username} si vous avez plusieurs demandes.")
						else
							error_message(sender, sms_id, service_id, "Vous avez déjà envoyé une demande à cet utilisateur veuillez attendre sa réponse ou envoyer une demande à quelqu'un d'autre.")
						end
					else
						error_message(sender, sms_id, service_id, "Cet utilisateur est déjà en couple, veuillez en choisir un autre.")
					end
				end
  		end
  	end
  end
  
  def accept?(content)
  	if /^#{Parameter.first.accept}/i.match(content).eql?(nil)
  		false
  	else
  		true
  	end
  end
  
  def accept(sender, sms_id, service_id, content)
  	@relations = Relation.where("target = '#{sender}' AND created_at = updated_at")
  	@initiator = ''
  	@target = ''
  	if @relations.empty?
  		error_message(sender, sms_id, service_id, "Désolé, vous n'avez reçu aucune demande.")
  	else
# user received only one demand
  		if @relations.count.eql?(1)	
  			@relations.each do |relation|
  				@target = User.find_by_phone_number(relation.target)
  				@initiator = User.find_by_id(relation.user_id)
  				
  				relation.update_attributes(:status => true)
  				@target.update_attributes(:in_couple_with => @initiator.username)
  				@initiator.update_attributes(:in_couple_with => @target.username) 	
  				error_message(sender, sms_id, service_id, "Vous êtes maintenant en couple avec #{@initiator.username}")
  				error_message(sender, sms_id, service_id, "Vous êtes maintenant en couple avec #{@target.username}")			
				end
  		else
# user received several demands
  			content = content.sub(/^#{Parameter.first.accept}/i, '').strip
  			if /\b.+?\b/.match(content).eql?(nil)
  				error_message(sender, sms_id, service_id, "Vous avez reçu plusieurs demandes veuillez préciser le nom. Exemple: #{Parameter.first.accept} christian")
  			else
  				@target = /\b.+?\b/.match(content).to_s  		
# username doesnt exists
  				if User.find_by_username(@target).eql?(nil)
  					error_message(sender, sms_id, service_id, "Cet utilisateur n'existe pas.")
  				else
# user which send the demand is already in couple
  					if User.find_by_username(@target).in_couple_with.eql?(nil)
  						@swain1 = User.find_by_username(@target)
  						@swain2 = User.find_by_phone_number(sender)
  						@relations = Relation.where("target = '#{sender}' AND created_at = updated_at AND user_id = #{@swain1.id}")
  						@relations.each do |relation|
  							relation.update_attributes(:status => true)
  							@swain1.update_attributes(:in_couple_with => @swain2.username)
  							@swain2.update_attributes(:in_couple_with => @swain1.username)
  							error_message(sender, sms_id, service_id, "Vous êtes maintenant en couple avec #{@swain1.username}")
  				error_message(sender, sms_id, service_id, "Vous êtes maintenant en couple avec #{@swain2.username}")
  						end
  					else
  						error_message(sender, sms_id, service_id, "Cet utilisateur s'est déjà mis en couple avec quelqu'un d'autre.")
  					end
  				end
  			end
  		end
  	end
  end
  
  def research?(content)
# content must begin with a number
  	@age1 = /^[0-9][0-9]/.match(content)
  	@age2 = ''
  	if @age1.eql?(nil)
  		false
  	else
  		#@age2 = /\b[1-4][0-9]\b/.match(content.sub(@age1, '').strip)
  		#if @age2.eql?(nil)
  			#false
  		#else
  			true
  		#end
  	end 	
  end
  
  def research(sender, sms_id, service_id, content)
# look for a number inside the whole string
  	@age_min = /\b[0-9][0-9]\b/.match(content).to_s
  	@age_max = ''#/\b[0-9][0-9]\b/.match(content.sub(@age1, '').strip).to_s
  	if /\b[0-9][0-9]\b/.match(content.sub(@age_min, '').strip).eql?(nil)
  		@age_max = @age_min
  	else
  		@age_max = /\b[0-9][0-9]\b/.match(content.sub(@age_min, '').strip).to_s
  	end
  	@tmp = ''
  	@results = ''
  	#@infos = ''
  	if @age_min.to_i > @age_max.to_i
  		@tmp = @age_min.to_i
  		@age_min = @age_max.to_i
  		@age_max = @tmp		
  	end
  	@gender = research_gender(User.find_by_phone_number(sender).gender)
  	content = content.sub(@age_min.to_s, '').sub(@age_max.to_s, '').strip
  	if /^[a-z 0-9]+$/.match(content).eql?(nil)
  		@results = research_results(@age_min, @age_max, @gender, /^[a-z 0-9]+$/.match(content))
  		if @results.empty?
  			@results = 'Aucun résultat trouvé.'
  		end
  		error_message(sender, sms_id, service_id, @results)
  	else
  		if User.where(:age => (@age_min..@age_max), :gender => @gender, :area => /^[a-z 0-9]+$/.match(content).to_s).empty?
  			@results = research_results(@age_min, @age_max, @gender, nil)
  			if @results.empty?
  				@results = 'Aucun résultat trouvé.'
  			end
  			error_message(sender, sms_id, service_id, @results)
  		else
  			@results = research_results(@age_min, @age_max, @gender, /^[a-z 0-9]+$/.match(content))
  			if @results.empty?
  				@results = 'Aucun résultat trouvé.'
  			end
  			error_message(sender, sms_id, service_id, @results)
  		end
  	end  		
  end 
  
  def research_gender(content)
  	@gender = ''
  	if /\bf\b/i.match(content).eql?(nil)
  		@gender = 'f'
  	else
  		@gender = 'h'
  	end
  	@gender
  end
  
  def research_results(age_min, age_max, gender, area)
  	@infos = ''
  	@area = ''
  	@res = ''
  	if area.eql?(nil)
  		@users = User.where(:age => (age_min..age_max), :gender => gender, :in_couple_with => nil).random(5)
  	else
  		@users = User.where(:age => (age_min..age_max), :gender => gender , :area => area.to_s, :in_couple_with => nil).random(5)
  	end
  	@users.each do |user|
  		if user.infos.eql?(nil)
  			@infos = ''
  		else
  			@infos = ' (i)'
  		end
  		if user.area.eql?(nil)
  			@area = ''
  		else
  			@area = "habite #{user.area}"
  		
  		end		
  		@res = @res << user.username << @infos << ': ' << user.age.to_s << ' ans ' << @area << ' | '
  	end
  	@res  	
  end
  
  def pull_and_push?(sender, receiver)
  	@orange = operator_prefixes('orange')
  	@mtn = operator_prefixes('mtn')
  	@green = operator_prefixes('green')
  	@koz = operator_prefixes('koz')
  	
  	@operators = [@orange, @mtn, @green, @koz]

		@pull_and_push = 'http://localhost:3001/'
		/(..)(......)$/ =~ sender
		@sender_indicator = $1
		/(..)(......)$/ =~ receiver
		@receiver_indicator = $1 
	
		@operators.each do |operator|
			@pull_and_push = 'http://localhost:3001/' if (operator.include?(@sender_indicator) && operator.include?(@receiver_indicator))
		end
		@pull_and_push
	end
	
	def operator_prefixes(operator_name)
		@prefixes = []
		Operator.find_by_name(operator_name).prefixes.each do |prefix|
  		@prefixes << prefix.name
  	end
  	@prefixes
	end
  	  
  def send_message(message)
  	Container.create(:content => message)
  end
  
  def error_message(sender, sms_id, service_id, content)
  	request = Typhoeus::Request.new("http://localhost:3001/",
                                :headers       => {:Accept => "text/html"},
                                :params        => {
																										:receiver => sender,
																										:sms_id => sms_id,
																										:service_id => service_id,
																										:content => content
																									})
		hydra = Typhoeus::Hydra.new
		hydra.queue(request)
		hydra.run
  end
  
  def forward_message(sender, sms_id, service_id, content)
  	@sender = User.find_by_phone_number(sender).username
  	@receiver = User.find_by_username(User.find_by_phone_number(sender).in_couple_with).phone_number
  	request = Typhoeus::Request.new(pull_and_push?(sender, @receiver),
                                :headers       => {:Accept => "text/html"},
                                :params        => {
																										:sender => sender,
																										:receiver => @receiver,
																										:sms_id => sms_id,
																										:service_id => service_id,
																										:content => content
																									})
		hydra = Typhoeus::Hydra.new
		hydra.queue(request)
		hydra.run
  end
  
  def current_user
    return unless session[:administrator_id]
    @current_user ||= Administrator.find_by_id(session[:administrator_id])
  end
  # Make current_user available in templates as a helper
  helper_method :current_user
  # Filter method to enforce a login requirement
  # Apply as a before_filter on any controller you want to protect
  def authenticate
    logged_in? ? true : access_denied
  end
  # Predicate method to test for a logged in user
  def logged_in?
    current_user.is_a? Administrator
  end
  # Make logged_in? available in templates as a helper
  helper_method :logged_in?

  #def owned_bay?(owner)
  #  return true if (owner.is_a? User) && (owner.profile.user_id.eql?(owner.id)) else redirect_to navigations_path
  #end
  #helper_method :owned_bay?
  
  def access_denied
    redirect_to login_path, :notice => "Veuillez vous enregistrer pour continuer" and return false
  end
  
end
