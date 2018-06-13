class Chat
	#TODO add method that creates the database and collection
	# global variables
	@@client = nil
	@@last = nil
	@@greeted = false
	@@db = nil
	
	# global variable for simple NLG use
	@@nlg = SimpleNLG::NLG
	
	# class constructor
	def initialize
		require "mongo"
		@@db = Mongo::Connection.new("192.168.10.203", 27017).db("chat")
		#db = Mongo::Client.new([ '192.168.10.203:27017' ], :database => 'chat')
		#db = connect("192.168.10.203:27017/chat")
		#mongo --username web --password dev123 --host 192.168.10.203 --port 27017
		
		# create a new instance of wit with the appropriate access token
		@@client = Wit.new(access_token: "YNOAZ2VDYQAVYP2BLIAKBRIDP622CMVU")
	end
	
	def getData type
		things = @@db.collection("saves")
		cursor = things.find()
		cursor.each { |row| 
			if(row[type] != nil)
				puts row[type]
			end
		} 
	end
	
	# method for determining intent(s) of the user input
	def first_entity_value(entities, entity)
	  return nil unless entities.has_key? entity
	  val = entities[entity][0]["value"]
	  return nil if val.nil?
	  return val.is_a?(Hash) ? val["value"] : val
	end

	# method for regreeting the user after they have already been greeted
	def regreet
		# array of questions to get user problems/questions
		offer = ["Can I help you?", "How can I help you?", "Do you need help?", "What can I help you with?"]
		
		# create regreet phrase
		sentence = "I remember you! " + offer.sample
		
		# return generated sentence
		return sentence
	end
	
	# method for greeting the user
	def greeting
		# arrray of greetings
		greetings = ["Hey!", "Hello!", "Good day!", "Greetings!", "Hi!"]
		# array of questions to get user problems/questions
		offer = ["Can I help you?", "How can I help you?", "Do you need help?", "What can I help you with?"]
		
		# get a random value from both arrays
		g = greetings.sample
		o = offer.sample
		
		# create greeting phrase
		sentence = g + " " + o
		
		# return generated sentence
		return sentence
	end
	
	# method for getting the name of the form that the user is on
	def getForm
		# return form name
		return "W4 Federal"
	end
	
	# method for writing user input to a file
	def writeToFile(type, text)
		things = @@db.collection("saves")
		
		things.insert(type => text)
	end
	
	# method for handling user input
	def handle_message(response)
		# get form name
		form = getForm()
		
		# check to see if the word 'form' is in the form name
		if (form.include? "form") || (form.include? "Form")
			# if so, remove it
			form = form.gsub("form", "")
			form = form.gsub("Form", "")
		end
		
		# get user entry text
		entry = response["_text"]
		
		# get API response
		entities = response["entities"]
		  
		  
		
		# IMPORTANT: a user input may have many intents
		
		# get greetings intent
		greetings = first_entity_value(entities, "greetings")
		# get problem intent
		problem = first_entity_value(entities, "problem")
		# get question intent
		question = first_entity_value(entities, "question")
		# get field_problem intent
		field_problem = first_entity_value(entities, "field_problem")
		
		# check if user entry is save, update, or remove	
			# append last user input to file
		if entry == "save"
			writeToFile("save", @@last)
			return "Saving: " + @@last
		elsif entry == "update"
			writeToFile("update", @@last)
			return "Update: " + @@last
		elsif entry == "remove"
			writeToFile("remove", @@last)
			return "Remove: " + @@last
		else		
			# set variable to last user entry
			@@last = entry
			
			# switch/case
			case
			# when intent is problem
			when problem
				# check if problem is opening the form
				if problem == "open"
					return "You are having a problem opening the " + form + " form"
				# check if problem is a field on the form
				elsif problem == "field"
					# check for common field problems
					if field_problem == "locked"
						return "You are having a problem with a locked field on the " + form + " form"
					elsif field_problem == "validation"
						return "You are having a problem with a non-validated field on the " + form + " form"
					else
						return "You are having a problem with a field on the " + form + " form"
					end
				# check if problem is closing a form
				elsif problem == "closure"
					return "You are having a problem closing the " + form + " form"
				else
					return "You are having a problem with the " + form + " form"
				end
			# check if intent is question
			when question
				return "You are asking a question"
			# check if intent is greeting
			when greetings
				# check if already greeted
				if !@@greeted
					# set variable to true
					@@greeted = true
					# greet user
					return greeting()
				else
					# otherwise, regreet user
					return regreet()
				end
			# if no intent is matched
			else
				# ask for rephrasal
				return "Please re-phrase your input"
			end
		end
	end
	
	# method for user to reply to the chatbot
	def reply msg
		# get message from user and send it to the API
		rep = @@client.message(msg)
		# process message
		puts handle_message(rep)
		
		# interactive Wit
		#@@client.interactive(method(:handle_message))
	end
end