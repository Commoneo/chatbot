# Decision class
# Written by Jordan Halaby
# Purpose is classify a record with decision tree
# Version 1.0

# Decision class
class Decision
	
	# Record class
	class Record
		# class variables
		@attributes = Array.new
		@className = nil
		
		# class constructor
		def initialize(atts, clname)
			@attributes = atts
			@className = clname
		end
		
		# methoed for returning class name
		def className
			@className
		end
		
		# method for returning attributes
		def atts
			@attributes
		end
	end
	
	# Node class
	class Node
		# class variables
		@nodeType = nil
		@condition = nil
		@className = nil
		@left = nil
		@right = nil
		
		# class constructor
		def initialize(nodeT, val, left, right)
			# set variables
			@nodeType = nodeT
			@left = left
			@right = right
			
			# set variables based on node type
			if(nodeT == "internal")
				@condition = val
				@className = -1
			else
				@className = val
				@condition = -1
			end
		end
		
		# method for returning class name
		def clname
			@className
		end
		
		# method for returning left Node
		def left
			@left
		end
		
		# method for returning right Node
		def right
			@right
		end
		
		# method for returning Node type
		def type
			@nodeType
		end
		
		# method for returning condition name
		def condition
			@condition
		end
	end
	
	# method for changing the return value of the object
	def inspect
		@root
		@records
		@attributes
		@numberRecords
		@numberAttributes
		@numberClasses
		
		# return current object
		self
	end
	
	# metho for calling classification 
	def go(params)
		# test array of 1's and 0's
		ret = test(params)
		
		# return classification
		return ret
	end
	
	# constructor for class
	def initialize
		# initialize variables
		@root = nil
		@records = Array.new
		@attributes = Array.new
		@numberRecords = 0
		@numberAttributes = 0
		@numberClasses = 0
		
		# load training data from file
		loadTrainingData("./dtrain.txt")
		
		# build decision tree
		buildTree()
	end
	
	# method for testing the input record
	def test arr
		# initialize variable
		ret = 0
		
		# go through each of training records
		@records.each{|rec|
			# get current training record attributes
			at = rec.atts
			
			# get length
			len = at.length
			
			# set flag
			flag = true
			
			# go through all attributes
			len.times{|x|
				# check if attribute is not equal to input attribute
				if(at[x] != arr[x])
					# change flag
					flag = false
				end
			}
			# check flag
			if(flag)
				# get class name
				ret = rec.className
				break
			end
		}
		
		# return class name
		return ret
	end
	
	# method for building tree
	def buildTree
		# call build method
		@root = build(@records, @attributes)
	end
	
	# method for building tree
	def build(records, attributes)
		# initialize variable
		ret = nil
		
		# check if same class
		if(sameClass(records))
			# get class name
			classname = records[0].className
			
			# create new leaf Node object
			ret = Node.new("leaf", classname, nil, nil)
		# check if attributes are empty
		elsif attributes.empty?
			# get majority class
			classname = majorityClass(records)
			
			# create new leaf Node object
			ret = Node.new("leaf", classname, nil, nil)
		# otherwise
		else
			# get best condition
			condition = bestCondition(records, attributes)
			
			# get left and right records with collect method
			leftRecords = collect(records, condition, 0)
			rightRecords = collect(records, condition, 1)
			
			# check if either array is empty
			if(leftRecords.empty? || rightRecords.empty?)
				# get majority class
				className = majorityClass(records)
				# create new leaf Node object
				ret = Node.new("leaf", className, nil, nil)
			# otherwise
			else
				# copy attributes for left and right
				leftAttributes = copyAttributes(attributes)
				rightAttributes = copyAttributes(attributes)
				
				rightAttributes = rem(rightAttributes, condition)
				leftAttributes = rem(leftAttributes, condition)
				
				# recursively call build on left and right records/attributes
				left = build(leftRecords, leftAttributes)
				right = build(rightRecords, rightAttributes)
				
				# create new internal Node object
				ret = Node.new("internal", condition, left, right)
			end
		end
		
		# return Node object
		ret
	end
	
	# method for classifying test input
	def classify atts
		# get root Node
		current = @root
		
		# loop while Node type is internal
		while current.type == "internal"
			# check if traverse left or right
			if(atts[current.condition-1] == 0)
				current = current.left
			else
				current = current.right
			end
		end
		
		# display classified class name
		puts current.clname
	end
	
	# method for removing attributes
	def rem(atts, condition)
		# create new array
		result = Array.new
		# get number of attributes
		size = atts.length
		
		# loop through number of attributes
		size.times{|s|
			# check if attributes meet condition
			if(atts[s] != condition)
				# push attribute onto result array
				result.push(atts[s])
			end
		}
		
		# return result array
		result
	end
	
	# method for copying attributes
	def copyAttributes(attributes)
		# create result array
		result = Array.new
		# get number of attributes
		size = attributes.length
		
		# loop through number of attributes
		size.times{|i|
			# get current attribute
			temp = attributes[i]
			# push attribute onto result array
			result.push(temp)
		}
		
		# return result array
		result
	end
	
	# method for determining best condition
	def bestCondition(records, attributes)
		# get minimum value from evaluate method
		minValue = evaluate(records, attributes[0])
		
		# initialize varriable
		minIndex = 0
		# get number of training records
		size = records.length
		
		# loop through number of training records
		size.times{|i|
			# evaluate on current attribute
			value = evaluate(records, attributes[i])
			
			# check for new min value
			if(value < minValue)
				minValue = value
				minIndex = i
			end
		}
		
		# get attribute
		ret = attributes[minIndex]
		
		# return attribute
		ret
	end
	
	# method for evaluating records
	def evaluate(records, attribute)
		# collect left and right records
		leftRecords = collect(records, attribute, 0)
		rightRecords = collect(records, attribute, 1)
		
		# calculate left and right entropy
		entropyLeft = entropy(leftRecords)
		entropyRight = entropy(rightRecords)
		
		# get lengths
		leftSize = leftRecords.length
		rightSize = rightRecords.length
		size = records.length
		
		# normalize by size
		left = entropyLeft*leftSize/size
		right = entropyRight*rightSize/size
		
		# compute average
		average = left + right
		
		# return average
		average
	end
	
	# method for calculating Gini entropy
	def entropy(records)
		# create a new array
		frequency = Array.new
		
		# loop through all classes
		@numberClasses.times{|i|
			# initialize array element
			frequency[i] = 0.0
		}
		
		# get number of records
		size = records.length
		# loop through number of records
		size.times{|i|
			# calculate frequency
			c = records[i].className-1
			frequency[c] += 1
		}
		
		# initialize variable
		sum = 0.0
		# loop through number of classes
		@numberClasses.times{|i|
			# add frequency to sum
			sum = sum + frequency[i]
		}
		
		# loop through number of classes
		@numberClasses.times{|i|
			# calculate frequency
			frequency[i] = frequency[i]/sum
		}
		
		# reset variable
		sum = 0.0
		# loop through number of classes
		@numberClasses.times{|i|	
			# increment sum
			sum = sum + frequency[i]*frequency[i]
		}
		
		# calculate entropy
		ret = 1 - sum
		
		# return entropy
		ret
	end
	
	# method for collecting records
	def collect(records, condition, value)
		# create array
		result = Array.new
		# get number of records
		size = records.length
		# loop through number of records
		size.times{|x|
			##### This had to be added in case condition is nil
			##### Might have to check this lataer
			if(condition)
				if(records[x].atts[condition - 1] == value)
					# push records to result array
					result.push(records[x])
				end
			end
		}
		
		
		# return result array
		result
	end
	
	# method for determining majority class
	def majorityClass(records)
		# create new array
		frequency = Array.new
		
		# loop through number of classes
		@numberClasses.times{|x|
			# initialize array element
			frequency[x] = 0
		}
		
		# get number of records
		size = records.length
		
		# loop through number of records
		size.times{|i|
			#num = records[i].className -1
			#frequency[num] +=1
			#puts frequency[num]
			
			# get frequency array element
			num = records[i].className
			v = num-1
			frequency[v] +=1
		}
		
		# set variable
		maxIndex = 0
		# loop through number of classes
		@numberClasses.times{|i|
			# check if frequency is increased
			if(frequency[i] > frequency[maxIndex])
				maxIndex = i
			end
		}
		
		# calculate return
		ret = maxIndex + 1
		
		
		# return
		ret
	end
	
	# method for determining if records are in the same class
	def sameClass(records)
		# get records length
		size = records.length
		
		# loop through number of records
		size.times{|x|
			# checck if class name is different
			if(records[x].className != records[0].className)
				# return false
				return false
			end
		}
		# return true
		return true
	end
	
	# method for obtaining training data
	def loadTrainingData trainingFile
		# create new array
		allLines = Array.new
		
		# get all lines
		lines = File.open(trainingFile).to_a
		
		# get first line
		fstLine = lines.first
		fstLine = fstLine.lstrip
		fstLine = fstLine.rstrip
		
		# get number of training records, attributes and classes
		data = fstLine.split
		@numberRecords = data[0].to_i
		@numberAttributes = data[1].to_i
		@numberClasses = data[2].to_i
		
		# loop through each line
		File.readlines(trainingFile).each do |line|
			line = line.lstrip
			line = line.rstrip
			if(line != fstLine && line.length > 0 && line != nil && line != "")
				# push current line to array
				allLines.push(line)
			end
		end
		
		# loop through array of all lines
		allLines.each{ |ln|
			# create new array
			attributeArray = Array.new
			# initialize variable
			claname = nil
			
			# split current liine
			comps = ln.split

			# initialize variable
			num = 0
			# loop through current line
			comps.each{ |p|
				# get attribute array and class name
				if(num < 27)
					ret = convertAttribute(p, num+1)
					attributeArray.push(ret)
					num +=1
				else
					label = p
					claname = convertString(p)
					num = 0
				end
			}
			
			# create new record
			rec = Record.new(attributeArray, claname)
			# push record to class array
			@records.push(rec)
		}
		
		# loop through number of attributes
		@numberAttributes.times{ |p|
			q = p + 1
			# push attribute to array
			@attributes.push(q)
		}
	end
	
	# method for converting class name to integer
	def convertString(label)
		value = nil
		
		if(label == "ONE")
			value = 1
		elsif(label == "TWO")
			value = 2
		elsif(label == "THREE")
			value = 3
		elsif(label == "FOUR")
			value = 4
		elsif(label == "FIVE")
			value = 5
		elsif(label == "SIX")
			value = 6		
		elsif(label == "SEVEN")
			value = 7		
		elsif(label == "EIGHT")
			value = 8		
		elsif(label == "NINE")
			value = 9		
		elsif(label == "TEN")
			value = 10		
		elsif(label == "ELEVEN")
			value = 11		
		elsif(label == "TWELVE")
			value = 12		
		elsif(label == "THIRTEEN")
			value = 13		
		elsif(label == "FOURTEEN")
			value = 14		
		elsif(label == "FIFTEEN")
			value = 15		
		elsif(label == "SIXTEEN")
			value = 16		
		elsif(label == "SEVENTEEN")
			value = 17		
		elsif(label == "EIGHTEEN")
			value = 18		
		elsif(label == "NINETEEN")
			value = 19		
		elsif(label == "TWENTY")
			value = 20		
		elsif(label == "TWENTYONE")
			value = 21		
		elsif(label == "TWENTYTWO")
			value = 22		
		elsif(label == "TWENTYTHREE")
			value = 23		
		elsif(label == "TWENTYFOUR")
			value = 24		
		elsif(label == "TWENTYFIVE")
			value = 25		
		elsif(label == "TWENTYSIX")
			value = 26		
		elsif(label == "TWENTYSEVEN")
			value = 27		
		elsif(label == "TWENTYEIGHT")
			value = 28		
		elsif(label == "TWENTYNINE")
			value = 29		
		elsif(label == "THIRTY")
			value = 30		
		elsif(label == "THIRTYONE")
			value = 31		
		elsif(label == "THIRTYTWO")
			value = 32		
		elsif(label == "THIRTYTHREE")
			value = 33		
		elsif(label == "THIRTYFOUR")
			value = 34		
		else
			value = 0		
		end
		
		# return integer
		value
	end
	
	# method for converting attribute to integer
	def convertAttribute(label, index)
		value = nil

		# if off switch
		if(label.include?"_off")
			value = 0
		# if on switch
		elsif(label.include?"_on")
			value = 1
		else
			value = 12
		end
		
		value
	end
end