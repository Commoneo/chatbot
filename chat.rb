class Chat
		@@client = nil
		@@last = nil
		@@greeted = false
		
		@@nlg = SimpleNLG::NLG
		
		def initialize
			@@client = Wit.new(access_token: "YNOAZ2VDYQAVYP2BLIAKBRIDP622CMVU")
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
		
		def getForm
			return "W4 Federal"
		end
		
		def handle_message(response)
			form = getForm()
			
			if (form.include? "form") || (form.include? "Form")
				form = form.gsub("form", "")
				form = form.gsub("Form", "")
			end
			
			entry = response["_text"]
			entities = response["entities"]
			  
			greetings = first_entity_value(entities, "greetings")
			problem = first_entity_value(entities, "problem")
			question = first_entity_value(entities, "question")
			field_problem = first_entity_value(entities, "field_problem")
			
			if entry == "save"
				open("save.txt", "a") do |f|
				  f.puts "Saving: " + @@last
				end
				return "Saving: " + @@last
			elsif entry == "update"
				open("save.txt", "a") do |f|
				  f.puts "Update: " + @@last
				end
				return "Update: " + @@last
			elsif entry == "remove"
				open("save.txt", "a") do |f|
				  f.puts "Remove: " + @@last
				end
				return "Remove: " + @@last
			else						
				@@last = entry
				case
				when problem
					if problem == "open"
						return "You are having a problem opening the " + form + " form"
					elsif problem == "field"
						if field_problem == "locked"
							return "You are having a problem with a locked field on the " + form + " form"
						elsif field_problem == "validation"
							return "You are having a problem with a non-validated field on the " + form + " form"
						else
							return "You are having a problem with a field on the " + form + " form"
						end
					elsif problem == "closure"
						return "You are having a problem closing the " + form + " form"
					else
						return "You are having a problem with the " + form + " form"
					end
				when question
					return "You are asking a question"
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
			#@@client.interactive(method(:handle_message))
		end
end