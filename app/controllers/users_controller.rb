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
  end
  
  def reports
  	@users = User.all
  	respond_to do |format|
  		format.html
  		format.csv
  	end
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
