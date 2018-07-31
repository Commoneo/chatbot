class Chat
	@@client = nil
	@@last = nil
	@@greeted = false
	@@db = nil
	@@form = nil
	@@form_index = nil
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
	  if(entity == "question_type")
			val = entities[entity][1]["value"]
	  else
		val = entities[entity][0]["value"]
	  end
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
			@@form_index = frm
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
		
		question_type = first_entity_value(entities, "question_type")
		
		question_content_why = first_entity_value(entities, "why_questions")
		question_content_which = first_entity_value(entities, "which_questions")
		question_content_can = first_entity_value(entities, "can_questions")
		question_content_what = first_entity_value(entities, "what_questions")
		question_content_does = first_entity_value(entities, "does_questions")
		question_content_how = first_entity_value(entities, "how_questions")
		question_content_who = first_entity_value(entities, "who_questions")
		
		question_object_obtain = first_entity_value(entities, "obtain_object")
		question_object_waive = first_entity_value(entities, "waive_object")
		question_object_need = first_entity_value(entities, "need_object")
		question_object_posses = first_entity_value(entities, "posses_object")
		question_object_acts = first_entity_value(entities, "acts_object")
		question_object_click = first_entity_value(entities, "click_object")
		question_object_result = first_entity_value(entities, "result_object")
		question_object_know = first_entity_value(entities, "know_object")
		question_object_fill = first_entity_value(entities, "fill_object")
		question_object_related = first_entity_value(entities, "related_object")
		question_object_mean = first_entity_value(entities, "mean_object")
		question_object_provide = first_entity_value(entities, "provide_object")
		
		coverage_action = first_entity_value(entities, "coverage_action")
		
		location_india = first_entity_value(entities, "location_india")
		
		action_verb = first_entity_value(entities, "action_verb")
		
		navigate_to = first_entity_value(entities, "navigate_to")
		
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
					question_type_dec = nil
					if(question_type == "what")
						question_type_dec = 9
					elsif(question_type == "how")
						question_type_dec = 10
					elsif(question_type == "why")
						question_type_dec = 7
					elsif(question_type == "which")
						question_type_dec = 8
					elsif(question_type == "who")
						question_type_dec = 4
					elsif(question_type == "when")
						question_type_dec = 5
					elsif(question_type == "where")
						question_type_dec = 1
					elsif(question_type == "does")
						question_type_dec = 2
					elsif(question_type == "should")
						question_type_dec = 6
					elsif(question_type == "can")
						question_type_dec = 3
					else
						question_type_dec = 0
					end
					
					question_content_dec = nil
					
					
					if(question_content_why == "can't fill")
						question_content_dec = 1
					elsif(question_content_why == "form in queue")
						question_content_dec = 2
					elsif(question_content_why == "necessary")
						question_content_dec = 3
					elsif(question_content_why == "click")
						question_content_dec = 4
					elsif(question_content_why == "in queue")
						question_content_dec = 5
					elsif(question_content_why == "provide")
						question_content_dec = 6
					
					elsif(question_content_which == "side")
						question_content_dec = 7
					
					elsif(question_content_can == "provide")
						question_content_dec = 8
					
					elsif(question_content_what == "purpose")
						question_content_dec = 9
					elsif(question_content_what == "required")
						question_content_dec = 10
					elsif(question_content_what == "upload")
						question_content_dec = 11
					elsif(question_content_what == "options")
						question_content_dec = 12
					elsif(question_content_what == "mean")
						question_content_dec = 13
					elsif(question_content_what == "not-posses")
						question_content_dec = 14
					elsif(question_content_what == "code")
						question_content_dec = 15
					elsif(question_content_what == "result")
						question_content_dec = 16
					elsif(question_content_what == "action")
						question_content_dec = 17
					elsif(question_content_what == "waived")
						question_content_dec = 18
					elsif(question_content_what == "fill")
						question_content_dec = 19
					
					elsif(question_content_does == "related")
						question_content_dec = 20
					
					elsif(question_content_how == "logon")
						question_content_dec = 21
					elsif(question_content_how == "years")
						question_content_dec = 22
					elsif(question_content_how == "obtain")
						question_content_dec = 23
					elsif(question_content_how == "age")
						question_content_dec = 24
					elsif(question_content_how == "know")
						question_content_dec = 25
					elsif(question_content_how == "navigate")
						question_content_dec = 26
					
					elsif(question_content_who == "fill")
						question_content_dec = 27
					elsif(question_content_who == "acts")
						question_content_dec = 28
					
					else
						question_content_dec = 0
					end
					
					question_object_dec = nil
					
					if(question_object_obtain == "direct deposit")
						question_object_dec = 1
					elsif(question_object_waive == "benefits")
						question_object_dec = 2
					elsif(question_object_waive == "coverage")
						question_object_dec = 3
					elsif(question_object_need == "upload")
						question_object_dec = 4
					elsif(question_object_need == "fill")
						question_object_dec = 5
					elsif(question_object_posses == "information")
						question_object_dec = 6
					elsif(question_object_posses == "equipment")
						question_object_dec = 7
					elsif(question_object_acts == "certificate holder")
						question_object_dec = 8
					elsif(question_object_click == "Cancel EFT")
						question_object_dec = 9
					elsif(question_object_click == "New EFT Account")
						question_object_dec = 10
					elsif(question_object_result == "advertise")
						question_object_dec = 11
					elsif(question_object_know == "eligible")
						question_object_dec = 12
					elsif(question_object_know == "sick leave benefits")
						question_object_dec = 13
					elsif(question_object_fill == "supporting document")
						question_object_dec = 14
					elsif(question_object_fill == "page")
						question_object_dec = 15
					elsif(question_object_fill == "form")
						question_object_dec = 16
					elsif(question_object_fill == "employment gap")
						question_object_dec = 17
					elsif(question_object_fill == "it")
						question_object_dec = 18
					elsif(question_object_related == "myself")
						question_object_dec = 19
					elsif(question_object_related == "someone")
						question_object_dec = 20
					elsif(question_object_related == "representative")
						question_object_dec = 21
					elsif(question_object_mean == "coverage")
						question_object_dec = 22
					elsif(question_object_provide == "typed letter")
						question_object_dec = 23
					elsif(question_object_provide == "written letter")
						question_object_dec = 24
					elsif(question_object_provide == "letter")
						question_object_dec = 25
					else
						question_object_dec = 0
					end
					
					coverage_action_dec = nil
					if(coverage_action == "waive")
						coverage_action_dec = 1
					elsif(coverage_action == "accept")
						coverage_action_dec = 2
					else
						coverage_action_dec = 0
					end
		
					location_india_dec = nil
					if(location_india == "true")
						location_india_dec = 1
					elsif(location_india == "false")
						location_india_dec = 2
					else
						location_india_dec = 0
					end
		
					action_verb_dec = nil
					if(action_verb == "waive")
						action_verb_dec = 1
					else
						action_verb_dec = 0
					end
					
					navigate_to_dec = nil
					if(navigate_to == "application")
						navigate_to_dec = 1
					elsif(navigate_to == "completed application")
						navigate_to_dec = 2
					else
						navigate_to_dec = 0
					end
					
					
					type = "0"
					question_type_bin = convert(question_type_dec, "quesiton_type")
					question_content_bin = convert(question_content_dec, "question_content")
					question_object_bin = convert(question_object_dec, "question_object")
					coverage_action_bin = convert(coverage_action_dec, "coverage_action")
					location_india_bin = convert(location_india_dec, "location_india")
					action_verb_bin = convert(action_verb_dec, "action_verb")
					navigate_to_bin = convert(navigate_to_dec, "navigate_to")
					
					str = question_type_bin + question_content_bin + question_object_bin + coverage_action_bin + location_india_bin + action_verb_bin + navigate_to_bin
					
					form_bin = convertform(@@form_index)
					str = form_bin + "" + type + "" + str
					
					final = Array.new
					vals = str.split("")
					vals.each{ |el|
						if(el == "1")
							final.push(1)
						elsif(el == "0")
							final.push(0)
						end
					}
					
					d = Decision.new
					d.go(final)
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
	
	def convertform(index)
		allForms = [
			Hash["binary" => "00000", "frm"=>"Other Form"],
			Hash["binary" => "00001", "frm"=>"Employment History Form"],
			Hash["binary" => "00010", "frm"=>"Scan of Diploma"],
			Hash["binary" => "00011", "frm"=>"I9 Supporting Documents"],
			Hash["binary" => "00100", "frm"=>"I9 Authorized Representative Form"],
			Hash["binary" => "00101", "frm"=>"Direct Deposit Documentation"],
			Hash["binary" => "00110", "frm"=>"Fieldglass User Guide"],
			Hash["binary" => "00111", "frm"=>"Withholdings Form"],
			Hash["binary" => "01000", "frm"=>"E-Verify Self Check Instructions"],
			Hash["binary" => "01001", "frm"=>"Self Check Results"],
			Hash["binary" => "01010", "frm"=>"Electronic Fund Transfer Authorization"],
			Hash["binary" => "01011", "frm"=>"Certificate of Insurance"],
			Hash["binary" => "01100", "frm"=>"Business Director Listing"],
			Hash["binary" => "01101", "frm"=>"Customer List"],
			Hash["binary" => "01110", "frm"=>"Equipment List"],
			Hash["binary" => "01111", "frm"=>"JPMC EJC Appplication Instructions"],
			Hash["binary" => "10000", "frm"=>"Hourly Consultant Benefits Waiver"],
			Hash["binary" => "10001", "frm"=>"Employment Application"],
			Hash["binary" => "10010", "frm"=>"Sick Leave Notice"],
			Hash["binary" => "10011", "frm"=>"I9 Form"],
			Hash["binary" => "10100", "frm"=>"ACA Benefits Election"]
		]
		
		return allForms[index]["binary"]
	end
	
	def convert(decimal, type)		
		navigate_to = [
			Hash["binary" => "00", "navigate" => "N/A"],
			Hash["binary" => "01", "navigate" => "Application"],
			Hash["binary" => "10", "navigate" => "Completed Application"]
		]
		action_verb = [
			Hash["binary" => "0", "action" => "N/A"],
			Hash["binary" => "1", "action" => "Waive"]
		]
		location_india = [
			Hash["binary" => "00", "india" => "N/A"],
			Hash["binary" => "01", "india" => "true"],
			Hash["binary" => "10", "india" => "false"]
		]
		coverage_action = [
			Hash["binary" => "00", "coverage" => "N/A"],
			Hash["binary" => "01", "coverage" => "Waive"],
			Hash["binary" => "10", "coverage" => "Accept"]
		]
		question_object = [
			Hash["binary" => "00000", "object" => "N/A"],
			Hash["binary" => "00001", "object" => "Direct Deposit"],
			Hash["binary" => "00010", "object" => "Benefits"],
			Hash["binary" => "00011", "object" => "Coverage"],
			Hash["binary" => "00100", "object" => "Upload"],
			Hash["binary" => "00101", "object" => "Fill"],
			Hash["binary" => "00110", "object" => "Information"],
			Hash["binary" => "00111", "object" => "Equipment"],
			Hash["binary" => "01000", "object" => "Certificate Holder"],
			Hash["binary" => "01001", "object" => "Cancel EFT"],
			Hash["binary" => "01010", "object" => "New EFT Account"],
			Hash["binary" => "01011", "object" => "Advertise"],
			Hash["binary" => "01100", "object" => "Eligible"],
			Hash["binary" => "01101", "object" => "Sick Leaave Benefits"],
			Hash["binary" => "01110", "object" => "Supporting Document"],
			Hash["binary" => "01111", "object" => "Page"],
			Hash["binary" => "10000", "object" => "Form"],
			Hash["binary" => "10001", "object" => "Employment Gap"],
			Hash["binary" => "10010", "object" => "It"],
			Hash["binary" => "10011", "object" => "Myself"],
			Hash["binary" => "10100", "object" => "Someone"],
			Hash["binary" => "10101", "object" => "Representative"],
			Hash["binary" => "10110", "object" => "Coverage"],
			Hash["binary" => "10111", "object" => "Typed Letter"],
			Hash["binary" => "11000", "object" => "Written Letter"],
			Hash["binary" => "11001", "object" => "Letter"]
		]
		quesiton_type = [
			Hash["binary" => "0000", "qtype" => "NA"],
			Hash["binary" => "0001", "qtype" => "Where"],
			Hash["binary" => "0010", "qtype" => "Does"],
			Hash["binary" => "0011", "qtype" => "Can"],
			Hash["binary" => "0100", "qtype" => "Who"],
			Hash["binary" => "0101", "qtype" => "When"],
			Hash["binary" => "0110", "qtype" => "Should"],
			Hash["binary" => "0111", "qtype" => "Why"],
			Hash["binary" => "1000", "qtype" => "Which"],
			Hash["binary" => "1001", "qtype" => "What"],
			Hash["binary" => "1010", "qtype" => "How"]
		]
		
		question_content = [
			Hash["binary" => "00000", "qcontent" => "N/A"],
			Hash["binary" => "00001", "qcontent" => "Can't Fill"],
			Hash["binary" => "00010", "qcontent" => "Form in Queue"],
			Hash["binary" => "00011", "qcontent" => "Necessary"],
			Hash["binary" => "00100", "qcontent" => "Click"],
			Hash["binary" => "00101", "qcontent" => "In Queue"],
			Hash["binary" => "00110", "qcontent" => "Provide"],
			Hash["binary" => "00111", "qcontent" => "Side"],
			Hash["binary" => "01000", "qcontent" => "Provide"],
			Hash["binary" => "01001", "qcontent" => "Purpose"],
			Hash["binary" => "01010", "qcontent" => "Required"],
			Hash["binary" => "01011", "qcontent" => "Upload"],
			Hash["binary" => "01100", "qcontent" => "Options"],
			Hash["binary" => "01101", "qcontent" => "Mean"],
			Hash["binary" => "01110", "qcontent" => "Not-Posses"],
			Hash["binary" => "01111", "qcontent" => "Code"],
			Hash["binary" => "10000", "qcontent" => "Result"],
			Hash["binary" => "10001", "qcontent" => "Action"],
			Hash["binary" => "10010", "qcontent" => "Waived"],
			Hash["binary" => "10011", "qcontent" => "Fill"],
			Hash["binary" => "10100", "qcontent" => "Related"],
			Hash["binary" => "10101", "qcontent" => "Logon"],
			Hash["binary" => "10110", "qcontent" => "Years"],
			Hash["binary" => "10111", "qcontent" => "Obtain"],
			Hash["binary" => "11000", "qcontent" => "Age"],
			Hash["binary" => "11001", "qcontent" => "Know"],
			Hash["binary" => "11010", "qcontent" => "Navigate"],
			Hash["binary" => "11011", "qcontent" => "Fill"],
			Hash["binary" => "11100", "qcontent" => "Acts"]
		]
		
		if(type == "quesiton_type")
			return quesiton_type[decimal]["binary"]
		elsif(type == "question_content")
			return question_content[decimal]["binary"]
		elsif(type == "question_object")
			return question_object[decimal]["binary"]
		elsif(type == "coverage_action")
			return coverage_action[decimal]["binary"]
		elsif(type == "location_india")
			return location_india[decimal]["binary"]
		elsif(type == "action_verb")
			return action_verb[decimal]["binary"]
		elsif(type == "navigate_to")
			return navigate_to[decimal]["binary"]
		end
	end
	
	def reply msg
		rep = @@client.message(msg)
		puts handle_message(rep)
		
		# interactive Wit
		#@@client.interactive(method(:handle_message))
	end
end