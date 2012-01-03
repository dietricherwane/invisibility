# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

	#before_filter :authenticate

  def index 
# récupération des paramètres de la requete
 		@sender = params[:sender]
 		@receiver = params[:receiver]
 		@sms_id = params[:sms_id]
 		@service_id = params[:service_id]
 		@content = params[:content].strip
 		
# compteur
		counter(@sender) 		
 		
 		if in_couple?(@sender)
 			if break_relationship?(@sender, @content)
 				clear_relationship(@sender, @sms_id, @service_id)
 			else
 				forward_message(@sender, @sms_id, @service_id, @content)
 			end
 		else
 					
# accessible aux utilisateurs enregistrés ayant complété leur profil 			
 			if (already_registered?(@sender) && profile_completed?(@sender))
	 			  							
		 			if update_area?(@content, @sender)
		 				update_area(@sender, @sms_id, @service_id, @content)
		 				exit
		 			end
		 			
		 			if infos?(@content, @sender)
		 				if get_infos?(@content)
		 					get_infos(@sender, @sms_id, @service_id, @content)
		 				else
		 					set_infos(@sender, @sms_id, @service_id, @content)
		 				end
		 				exit
		 			end
		 			
		 			if initiate?(@content)
						initiate(@sender, @sms_id, @service_id, @content)
						exit
		 			end
		 			
		 			if accept?(@content)
						accept(@sender, @sms_id, @service_id, @content)
						exit
		 			end
		 			
		 			if research?(@content)
						research(@sender, @sms_id, @service_id, @content)
						exit
		 			end
		 			
		 			error_message(@sender, @sms_id, @service_id, 'Aide') 
	 		end	

# l'utilisateur est enregistré mais n'a pas complété son profil'	 		
	 		if (already_registered?(@sender) && profile_completed?(@sender).eql?(false))
 				complete_profile(@sender, @sms_id, @service_id, @content)
 			end

# l'utilisateur souhaite s'enregistrer 		
 			if registration?(@content)
 				if already_registered?(@sender)
 					already_registered(@sender, @sms_id, @service_id) 
 				else
 					register_user(@sender, @sms_id, @service_id, @content)
 				end								
 			end

# l'utilisateur n'est pas enregistré et ne souhaite pas s'enregistrer 			
 			if already_registered?(@sender).eql?(false) && registration?(@content).eql?(false)
 				error_message(@sender, @sms_id, @service_id, "Veuillez d'abord vous enregistrer et compléter votre profil: Envoyez <tchat mon_pseudo> au 90xxxx")
 			end	
 		end
  end
  
  def stats
  	@parameters = Parameter.first
  	render 'parameters/edit'
  end
  
  def nombre_de_sms_par_utilisateur
  	@users_pagination = Counter.all.paginate(:page => params[:page], :per_page => 10)
  	@users = Counter.all
  	respond_to do |format|
  		format.html
  		format.csv
  	end
  end
  
  def nombre_de_sms_par_utilisateur_mail
  	@users = Counter.all
  	@pseudo = ''
  	CSV.open("#{RAILS_ROOT}/public/attachments/nombre_de_sms_par_utilisateur.csv", "wb", :col_sep => ";") do |csv|
  		csv << ["NUMERO DE TELEPHONE", "PSEUDONYME", "NOMBRE DE SMS ENVOYES"]
  		csv << ["", "", ""]
  		unless @users.eql?(nil)
				@users.each do |user|
					if User.find_by_phone_number(user.phone_number).eql?(nil)
						@pseudo = '-'
					else
						@pseudo = User.find_by_phone_number(user.phone_number).username 
					end 			
					csv << [user.phone_number, @pseudo, user.sms_number]
				end
  		end
		end
		Notifier.send_email('nombre_de_sms_par_utilisateur', current_user.email).deliver
  	redirect_to nombre_de_sms_par_utilisateur_path, :notice => 'Le rapport vous a été envoyé par mail.'
  	File.delete("#{RAILS_ROOT}/public/attachments/nombre_de_sms_par_utilisateur.csv")
  end
  
  def nombre_de_sms_par_couple
  	@users_pagination = Message.find_by_sql("SELECT user_id, receiver, COUNT(content) AS sms_number FROM messages GROUP BY user_id, receiver;").paginate(:page => params[:page], :per_page => 10)
  	@users = Message.find_by_sql("SELECT user_id, receiver, COUNT(content) AS sms_number FROM messages GROUP BY user_id, receiver;")
  	respond_to do |format|
  		format.html
  		format.csv
  	end
  end
  
  def nombre_de_sms_par_couple_mail
  	@users = Message.find_by_sql("SELECT user_id, receiver, COUNT(content) AS sms_number FROM messages GROUP BY user_id, receiver;")
  	CSV.open("#{RAILS_ROOT}/public/attachments/nombre_de_sms_par_couple.csv", "wb", :col_sep => ";") do |csv|
  		csv << ["NUMEROS DE TELEPHONE DU COUPLE", "PSEUDONYMES DU COUPLE", "NOMBRE DE SMS ECHANGES"]
  		csv << ["", "", ""]
  		unless @users.empty?
				@users.each do |user|			
					csv << ["#{User.find_by_id(user.user_id).phone_number} | #{user.receiver}", "#{User.find_by_id(user.user_id).username} | #{User.find_by_phone_number(user.receiver).username}", user.sms_number]
				end
  		end
		end
		Notifier.send_email('nombre_de_sms_par_couple', current_user.email).deliver
  	redirect_to nombre_de_sms_par_utilisateur_path, :notice => 'Le rapport vous a été envoyé par mail.'
  	File.delete("#{RAILS_ROOT}/public/attachments/nombre_de_sms_par_couple.csv")
  end
  
  def reports
  	@users = User.all
  	respond_to do |format|
  		format.html
  		format.csv
  	end
  end
  
  def send_email
  	Notifier.send_email.deliver
  	redirect_to stats_path, :notice => 'email envoyé.'
  	File.delete("#{RAILS_ROOT}/public/attachments/#{Time.now.strftime("%d-%m-%Y")}.csv")
  end
  
  def write_to_disk
  	@users = User.all
  	CSV.open("#{RAILS_ROOT}/public/attachments/#{Time.now.strftime("%d-%m-%Y")}.csv", "wb", :col_sep => ";") do |csv|
  		csv << ["Id", "Username", "Age", "Gender"]
  		@users.each do |user|  			
  			csv << [user.id, user.username, user.age, user.gender]
  		end
		end
		redirect_to send_email_path
  end
  	
# suppression des utilisateurs n'ayant pas complété leur profil deux jours après leur inscription'  
  def delete_latecomers
  	@latecomers = User.where("created_at = updated_at")
  	@latecomers.each do |latecomer|
  		if (Time.now - latecomer.created_at) > 2.days
  			latecomer.destroy
  		end
  	end
  end

end
