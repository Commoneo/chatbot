class Sentence		
	
	@@nlg = SimpleNLG::NLG
	
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