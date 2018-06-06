class Joke
		@@client = nil
		@@last = nil
		@@greeted = false
		
		@@nlg = SimpleNLG::NLG
		
		def initialize
			@@client = Wit.new(access_token: "MJDG6ULZO5LAYFD2T52MBHRMAIIO3ZOH")
		end
		
		def first_entity_value(entities, entity)
		  return nil unless entities.has_key? entity
		  val = entities[entity][0]['value']
		  return nil if val.nil?
		  return val.is_a?(Hash) ? val['value'] : val
		end

		@@all_jokes = {
		  'chuck' => [
			'Chuck Norris counted to infinity - twice.',
			'Death once had a near-Chuck Norris experience.',
		  ],
		  'tech' => [
			'Did you hear about the two antennas that got married? The ceremony was long and boring, but the reception was great!',
			'Why do geeks mistake Halloween and Christmas? Because Oct 31 === Dec 25.',
		  ],
		  'default' => [
			'Why was the Math book sad? Because it had so many problems.',
		  ],
		}
		def regreet
			offer = ['Can I help you?', 'How can I help you?', 'Do you need help?', 'What can I help you with?']
			
			sentence = "I remember you! " + offer.sample
			return sentence
		end
		
		def greeting
			greetings = ['Hey!', 'Hello!', 'Good day!', 'Greetings!', 'Hi!']
			who = ['I am an artificial intelligence chatbot!', 'I am a chatbot.']
			offer = ['Can I help you?', 'How can I help you?', 'Do you need help?', 'What can I help you with?']
			g = greetings.sample
			w = who.sample
			o = offer.sample
			
			sentence = g + " " + w + " " + o
			return sentence
		end
		
		def handle_message(response)
			entry = response["_text"]
		  entities = response['entities']
		  get_joke = first_entity_value(entities, 'getJoke')
		  greetings = first_entity_value(entities, 'greetings')
		  category = first_entity_value(entities, 'category')
		  sentiment = first_entity_value(entities, 'sentiment')

			if entry == "save"
				open('save.txt', 'a') do |f|
				  f.puts "Saving: " + @@last
				end
				return "Saving: " + @@last
			elsif entry == "update"
				open('save.txt', 'a') do |f|
				  f.puts "Update: " + @@last
				end
				return "Update: " + @@last
			elsif entry == "remove"
				open('save.txt', 'a') do |f|
				  f.puts "Remove: " + @@last
				end
				return "Remove: " + @@last
			else						
				@@last = entry
				  case
				  when get_joke
					if(@@all_jokes.has_key?(category))
						return @@all_jokes[category].sample
					else
						return @@all_jokes['default'].sample
					end
				  when sentiment
					bad = @@nlg.render{phrase(:s=>mod("I'm sad that","you"), :v=>"like", :o=>"my joke", :negation=>true, :tense=>:past)}
					good = @@nlg.render{phrase(:s=>mod("I'm glad that","you"), :v=>"like", :o=>"my joke", :tense=>:past)}
					return sentiment == 'positive' ? good : bad
				  when greetings
					if !@@greeted
						@@greeted = true
						return greeting()
					else
						return regreet()
					end
				  else
					return 'I can tell jokes! Say "tell me a joke about tech"!'
				  end
			end
		end
		
		def reply msg
			rep = @@client.message(msg)
			puts handle_message(rep)
			#@@client.interactive(method(:handle_message))
		end
end