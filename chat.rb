class Chat
	@@client = nil
	@@last = nil
	@@greeted = false
	@@db = nil
	@@form = nil
	@@processed = nil

	@@nlg = SimpleNLG::NLG
	
	@@forms = ["Withholdings Form", "Employment History Form", "Scan of Diploma", "I9 Supporting Documents", "I9 Authorized Representative Form", "Direct Deposit Documentation", "Fieldglass User Guide", "E-Verify Self Check Instructions", "Self Check Results", "Electronic Fund Transfer Authorization", "Certificate of Insurance", "Business Director Listing", "Customer List", "Equipment List", "JPMC EJC Appplication Instructions", "Hourly Consultant Benefits Waiver", "Employment Application", "Sick Leave Notice", "I9 Form", "ACA Benefits Election"]
	
	
	def initialize
		require "mongo"
		@@db = Mongo::Connection.new("192.168.10.203", 27017).db("chat")
		@@db.create_collection("saves")
		@@client = Wit.new(access_token: "BIRVT3TDZAI6R4R2WCEZS6XFVI5RPUCF")
	end
	
	def getData type
		things = @@db.collection("saves")
		cursor = things.find()
		cursor.each { |row| 
			if(row[type] != nil)
				frm = row["form"]
				if(frm == nil)
					frm = "N/A"
				end
				puts row[type] + " || Form: " + frm
			end
		} 
	end
	
	def first_entity_value(entities, entity)
	  return nil unless entities.has_key? entity
	  val = entities[entity][0]["value"]
	  return nil if val.nil?
	  return val.is_a?(Hash) ? val["value"] : val
	end

	def regreet
		offer = ["Can I help you?", "How can I help you?", "Do you need help?", "What can I help you with?"]
		
		sentence = "I remember you! " + offer.sample
		
		return sentence
	end
	
	def greeting
		greetings = ["Hey!", "Hello!", "Good day!", "Greetings!", "Hi!"]
		offer = ["Can I help you?", "How can I help you?", "Do you need help?", "What can I help you with?"]
		
		g = greetings.sample
		o = offer.sample
		
		sentence = g + " " + o
		
		return sentence
	end
	
	def getForm(entry)
		pieces = entry.split("||")
		frm = pieces[0]
		frm = frm.to_i
		
		if(frm < @@forms.length)
			frm = @@forms[frm]
		else
			frm = "N/A"
		end
		
		return frm
	end
	
	def writeToFile(type, text)
		things = @@db.collection("saves")
		
		frm = @@form
		
		if(!frm)
			frm = "N/A"
		end
		
		things.insert(type => text, "form" => frm)
	end
	
	def process_form(entry)
		@@processed = true
		if(entry.include?"||")
			@@form = getForm(entry)
			ins = entry.split("||")
			@@last = ins[1]
		else
			@@processed = false
			puts "You must specify a form in this format: 1||message"
		end
	end
	
	def handle_message(response)
		
		
		
		entry = response["_text"]
		
		entities = response["entities"]
		  
		  
		greetings = first_entity_value(entities, "greetings")
		type = first_entity_value(entities, "type")
		
		if(!@@last)
			@@last = "N/A"
		end
		
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
			
			case
			when type == "question" || type == "statement"
				process_form(entry)
				if(@@processed)
					return "You are asking a question for the following form: " + @@form
				else
					return nil
				end
			when greetings
				if !@@greeted
					@@greeted = true
					return greeting()
				else
					return regreet()
				end
			else
				return "Please re-phrase your input"
			end
		end
	end
	
	def reply msg
		rep = @@client.message(msg)
		puts handle_message(rep)
		
		# interactive Wit
		#@@client.interactive(method(:handle_message))
	end
end