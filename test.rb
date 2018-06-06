class Test
	@@nlg = SimpleNLG::NLG
		
	def initialize
		@@client = Wit.new(access_token: "YNOAZ2VDYQAVYP2BLIAKBRIDP622CMVU")
	end

	def first_entity_value(entities, entity)
		return nil unless entities.has_key? entity
		val = entities[entity][0]['value']
		return nil if val.nil?
		return val.is_a?(Hash) ? val['value'] : val
	end

	def handle_message(response)
		entry = response["_text"]
		entities = response['entities']
		
		problem = first_entity_value(entities, 'problem')
		question = first_entity_value(entities, 'question')
		field_problem = first_entity_value(entities, 'field_problem')
		
		case
		when problem
			if problem == "open"
				return "You are having a problem opening the form"
			elsif problem == "field"
				if field_problem == "locked"
					return "You are having a problem with a locked field on the form"
				elsif field_problem == "validation"
					return "You are having a problem with a non-validated field on the form"
				else
					return "You are having a problem with a field on the form"
				end
			elsif problem == "closure"
				return "You are having a problem closing the form"
			else
				return 'You are having a problem'
			end
		when question
			return 'You are asking a question'
		else
			return 'Please re-phrase your input'
		end
	end
	
	def reply msg
		rep = @@client.message(msg)
		puts handle_message(rep)
	end
end