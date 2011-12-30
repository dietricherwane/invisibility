# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create([{:username=>'dietrich', :phone_number=>'60086286', :gender=>'m', :age=>23, :in_couple_with=>'duke'}, {:username=>'duke', :phone_number=>'61086286', :gender=>'f', :age=>23, :in_couple_with=>'dietrich'}, {:username=>'nukem', :phone_number=>'08086286', :gender=>'m', :age=>23}])

User.first.relations.create(:target=>'61086286', :status=>true)

Operator.create([{:name => "orange"}, {:name => "mtn"}, {:name => "green"}, {:name => "koz"}])

Parameter.create(:break_relationship => "briser", :registration => "tchat", :area => "zone", :informations => "infos", :initiate_relationship => "initier", :accept => "accepter")
