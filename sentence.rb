class Sentence		
	
	@@nlg = SimpleNLG::NLG
	
	def responses
		#State that you were unemployed during that time period
		@@nlg.render{phrase(:s=>mod("State that", "you"), :v=>pre_mod("unemploy", "were"), :o=>pre_mod("that time period", "during"), :t=>"past")}
		
		# You must list between 7 to 10 years of employment
		@@nlg.render{phrase(:s=>"you", :v=>mod("must", "list"), :t=>"present", :o=>pre_mod("years of employment", "between 7 to 10"))}
		
		# You must provide final year marksheet and degree copy
		@@nlg.render{phrase(:s=>post_mod("you", "must provide"), :t=>"present", :o=>post_mod("final year marksheet", "and degree copy"))}
		
		# You must provide a copy of your degree
		@@nlg.render{phrase(:s=>post_mod("you", "must provide"), :t=>"present", :o=>post_mod("a copy of", "your degree"))}
		
		# The front and back of a document such as your drivers license, social security cardd, or birth certificate
		@@nlg.render{phrase(:s=>pre_mod("a document", "the front and back of"), :o=>post_mod("such as", "your drivers license, social security card, or birth certificate"))}
		
		# It is required for the I9 Form that you upload a supporting document
		@@nlg.render{phrase(:s=>pre_mod("the I9 Form", "it is required for"), :v=>mod("that you", "upload"), :o=>"a supporting document")}
		
		# You should upload both the front and back of the document
		@@nlg.render{phrase(:s=>pre_mod("should upload", "you"), :perfect=>:true, :o=>pre_mod("the document", "the front and back of"))}
		
		# This can be filled out by any person, related or not, that is over 18 years of age, has a valid email, and is not yourself.
		@@nlg.render{phrase(:s=>pre_mod("can be", "this"), :v=>"filled", :t=>"past", :o=>"out by any person, related or not, that is over 18 years of age, has a valid email, and is not yourself")}
	
		# For direct deposit documentation, you need to provide a typed letter
		@@nlg.render{phrase(:s=>pre_mod("direct deposit documentation, you", "for"), :v=>"need to provide", :t=>"future", :o=>"a typed letter")}
		
		# You must provide a typed letter so that you don't get linked to the wrong bank account
		@@nlg.render{phrase(:s=>post_mod("you must provide", "a typed letter so that you don't get"), :v=>"linked", :t=>"past", :o=>"to the wrong bank account")}
		
		# Follow the instructions
		@@nlg.render{"Follow the instructions"}
		
		# You are getting this form because you either work or live in this state
		@@nlg.render{phrase(s:"you", :v=>pre_mod("recieving","are"), :o=>post_mod("this form", "because you either work or live in this state"))}
		
		# Per company policy, this checks to see if the individual is eligible to work in the United States
		@@nlg.render{phrase(s:post_mod("per company policy,", "this"), :v=>mod("checks", "to see if the individual is eligible to work in"), :o=>"the United States")}
		
		# A picture of the green checkmark that confirms work authorization
		@@nlg.render{phrase(:s=>"a picture of the green checkmark", :v=>mod("that", "confirms"), :o=>"work authorization")}
		
		# You can determine if you are eligble by completing the E-Verify Self Check
		@@nlg.render{phrase(:s=>pre_mod("can", "you"), :v=>"determine", :o=>"if you are eligble by completing the E-Verify Self Check")}
		
		# You should click this when you want a paper check for payment
		@@nlg.render{phrase(:s=>mod("you", "should"), :v=>post_mod("click", "this when you want a"), :o=>"paper check for payment")}
		
		# You can get direct deposit by clicking the "New EFT Account" button
		@@nlg.render{phrase(:s=>"you", :v=>pre_mod("receive", "can"), :o=>"direct deposit by clicking the 'New EFT Account' button")}
		
		# The certicate holder is Commoneo and please supply our address
		@@nlg.render{phrase(:s=>"the certicate holder", :v=>"is", :o=>post_mod("Commoneo", "and please supply our address"))}
		
		# As an IC you must carry insurance required by the client
		@@nlg.render{phrase(:s=>pre_mod("IC, you must carry", "as an"), :o=>"insurance required by the client")}
		
		# You can upload any profile that shows that you represent yourself with
		@@nlg.render{phrase(:s=>"you", :v=>"can upload", :o=>"any profile that you represent yourself with")}
		
		# You can upload from, for example, Facebook, LinkedIn, etc.
		@@nlg.render{phrase(:s=>"you", :v=>"can upload", :o=>"from, for example, Facebook, LinkedIn, etc")}
		
		# The customer list helps to substantiate your validity as an IC in the case of an IRS audit
		@@nlg.render{phrase(:s=>"the customer list",  :v=>pre_mod("to substantiate", "helps"), :o=>"your validity as an IC in the case of an IRS audit")}
		
		# You must supply a list of your customers
		@@nlg.render{phrase(:s=>"you", :v=>post_mod("must", "supply"), :o=>"a list of your customers")}
		
		# Helps differentiate your status as an independent contractor as opposed to a W2
		@@nlg.render{phrase(:v=>post_mod("helps", "differentiate"), :o=>"your status as an independent contractor as opposed to a W2")}
		
		# Listing of any equipment that you bring with you on-site during a project
		@@nlg.render{phrase(:s=>"Listing of any equipment that you bring", :o=>"with you on-site during a project")}
		
		# Do you bring anything with you on-site? If so, list the items here
		@@nlg.render{"Do you bring anything with you on-site? If so, list the items here"}
		
		# The code is: JPMCCW ( colored in red )
		@@nlg.render{phrase(:s=>"the code", :v=>"is", :o=>"JPMCCW ( colored in red )")}
		
		# Go to applicationstation.com, use your previous username and paasword
		@@nlg.render{"Go to applicationstation.com, use your previous username and paasword"}
		
		# Follow the instructions on the JPMC EJC Application Instructions
		@@nlg.render{phrase(:s=>"Follow", :o=>"the instructions on the JPMC EJC Application Instructions")}
		
		# Any benefits that you are eligible for come from VSG and not from the client
		@@nlg.render{phrase(:s=>pre_mod("benefits that you are eligible for", "any"),  :v=>"come from", :o=>"VSG and not from the client")} 
		
		# Input "N/A" for those fields
		@@nlg.render{"Input 'N/A' for those fields"}
		
		# Scroll through this item and if your location is on it, you get benefits
		@@nlg.render{phrase(:s=>post_mod("scroll through this ","item"), :o=>"and if you location is on it, you get benefits")}
		
		# Accepting coverage doesn't necessarily mean you are enrolled
		@@nlg.render{phrase(:s=>post_mod("accepting coverage", "doesn't necessarily"), :o=>post_mod("mean you are", "enrolled"))}
		
		# Waiving coverage means that will not be enrolled in ACA benefits
		@@nlg.render{phrase(:s=>post_mod("waiving coverage"), :v=>"mean", :o=>post_mod("that you will not be enrolled in", "ACA benefits"))}
	end
	
	$list = [
		# A simple string
		@@nlg.render("mary is happy"),
		
		# simple sentenece from subject-verb-object: George fears the monkey
		@@nlg.render(:subject=>"George", :verb=>"fear", :object=>"the monkey"),
		
		# incomplete subject-verb-object: Nina cries
		@@nlg.render(:subject=>"Nina", :verb=>"cry"),
		
		# simple sentence from SVO hash input: Kate hates the donkey
		@@nlg.render(:s=>"Kate", :v=>"hate", :o=>"the donkey"),
		
		# handle particles in verb string: John picks up a coin
		@@nlg.render(:s=>"John", :v=>"pick up", :o=>"a coin"),
		
		# handle past tense: Dave learned several poems
		@@nlg.render(:s=>"Dave", :v=>"learn", :o=>"several poems", :tense=>:past),
		
		# handle future tense: Mike will find a way
		@@nlg.render(:s=>"Mike", :v=>"find", :o=>"a way", :tense=>:future),
		
		# handle explicit present tense: Oleg needs a break
		@@nlg.render(:s=>"Oleg", :v=>"need", :o=>"a break", :tense=>:present),
		
		# handle negation: Jennifer does not require more lessons
		@@nlg.render(:s=>"Jennifer", :v=>"require", :o=>"more lessons", :negation=>true),
		
		# handle negation as 'negated' and also altered tense: Dan did not catch the train
		@@nlg.render(:s=>"Dan", :v=>"catch", :o=>"the train", :negation=>true, :tense=>:past),
		
		# handle binary questions: Does Joshua know his father?
		@@nlg.render(:s=>"Joshua", :v=>"know", :o=>"his father"),
		
		# handle binary questions as yes_no with altered tense: Did Dimitry go to town?
		@@nlg.render(:s=>"Dimitry", :v=>"go", :o=>"to town", :interrogation=>:yes_no, :tense=>:past),
		
		# handle 'who' questions: Who went to town?
		@@nlg.render(:s=>"Kevin", :v=>"go", :o=>"to town", :interrogation=>:who, :tense=>:past),
		
		# handle negated who questions: Who does Simon help?
		@@nlg.render(:s=>"Simon", :v=>"help", :o=>"Martin", :q=>:who_object, :negated=>true),
		
		# handle negated who questions on the indierect object: Who does James bring the wine to?
		@@nlg.render(:s=>"James", :v=>"bring", :o=>"the wine", :q=>:who_indirect_object, :negated=>true),
		
		# handle where questions for the past tense: Where did Susan walk?
		@@nlg.render(:s=>"Susan", :v=>"walk", :interrogation=>:where, :tense=>:past),
		
		# handle how questions for the past tense: How does a bird fly
		@@nlg.render(:s=>"a bird", :v=>"fly", :interrogation=>:how),
		
		# handle what questions: What swims
		@@nlg.render(:s=>"a fish", :v=>"swim", :q=>:what),
		
		# handdle minimal negated what questions in future tense: What will not glow
		@@nlg.render(:v=>"glow", :interrogation=>:what, :negated=>true, :tense=>:future),
		
		# handle what_subject questions: What defeats rock?
		@@nlg.render(:s=>"paper", :v=>"defeat", :o=>"rock", :interrogation=>:what_subject),
		
		# handle onject-centic what questions in future tense: What will Gertrude play?
		@@nlg.render(:s=>"Gertrude", :v=>"play", :o=>"golf", :interrogation=>:what_object, :tense=>:future),
		
		# hanlde why questions: Why did the chicken cross the road?
		@@nlg.render(:s=>"the chicken", :v=>"cross", :o=>"the road", :interrogation=>:why, :tense=>:past),
		
		# produce passive voice: The speech was given by Michael
		@@nlg.render(:s=>"Michael", :v=>"give", :o=>"the speech", :passive=>true, :tense=>:past),
		
		# produce negated passive questions in future tense: Why will Bert not be respected by Jonathan
		@@nlg.render(:s=>"Jonathan", :v=>"respect", :o=>"Bert", :passive=>true, :q=>:why, :tense=>:future, :negation=>true),
		
		# accept a single complement: Newton hits Einstein with a ruler
		@@nlg.render(:s=>"Newton", :v=>"hit", :o=>"Einstein", :complement=>"with a ruler"),
		
		# accept multiple complements: Daniel took Olivia to a party for entertainment purposes
		@@nlg.render(:s=>"Daniel", :v=>"take", :o=>"Olivia", :complements=>["to a party", "for entertainment purpopses"], :tense=>:past),
		
		# accept multiple complements with shortcut: Who drank too much too often?
		@@nlg.render(:s=>"Steven", :v=>"drink", :c=>["too much", "too often"], :tense=>:past, :q=>:who_subject),
		
		# allow subject modifies: Holy Paul likes chess
		@@nlg.render(:s=>@@nlg.mod("Paul", "holy"), :v=>"like", :o=>"chess"),
		
		# allow subject modifiers from within an ugly notation: Crazy Nepomuk stole the money
		@@nlg.render{phrase(:s=>@@nlg.mod("Nepomuk", "crazy"), :v=>"steal", :o=>"the money", :tense=>:past)},
		
		# allow subject modifiers from within blocks: Lazy Karen slept long
		@@nlg.render{phrase(:s=>mod("Karen", "lazy"), :v=>mod("sleep", "long"), :tense=>:past)},
		
		# allow pre and post modifiers and allow for symbols as modifiers: Beautiful Monica went immediately to France
		@@nlg.render{phrase(:s=>pre_mod("Monica", "beautiful"), :v=>post_mod("go", "immediately"), :o=>"to France", :tense=>:past)},
		
		# mix modifiers and questions in past tense: What did smart Nathanael surely search?
		@@nlg.render{phrase(:s=>pre_mod("Nathanael", "smart"), :v=>pre_mod("search", "surely"), :tense=>:past, :q=>:what_object)},
		
		# mix modifiers and questions in present tense: What does dumb Gordon falsely assume?
		@@nlg.render{phrase(:s=>pre_mod("Gordon", "dumb"), :v=>pre_mod("assume", "falsely"), :tense=>:present, :q=>:what_object)},
		
		# modifiers have no influence on interrogation words: Who laughes?
		@@nlg.render{phrase(:s=>mod("Someone", "brown-eyed"), :v=>"laugh", :q=>:who)},
		
		# handle and-conjunctions as simple arrays in subject and object: Jane and Martha meet Olga and Roswitha
		@@nlg.render(:s=>["Jane", "Martha"], :v=>"meet", :o=>["Olga", "Roswitha"]),
		
		# handle and-conjuctions of more than one consitutent: Netty, Josephine and Lindsey chag
		@@nlg.render(:s=>["Netty", "Josephine", "Lindsey"], :v=>"chat"),
		
		# handle and-conjuctions of modified words in past tense: Suspicious Lana and Adam the coward disagreed
		@@nlg.render{phrase(:s=>[pre_mod("Lana", "suspicious"),post_mod("Adam", "the coward")], :v=>"disagree", :tense=>:past)}
	]
	
	def select (num)
		num.times do
			puts $list.sample
		end
	end
	
	def test
		help = @@nlg.render(:s=>"I'm glad you", :v=>"like", :o=>"my joke", :tense=>:past)
	end
	
end