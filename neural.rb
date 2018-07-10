class Neural
	
	@@records = Array.new
	
	class Record
		@input = Array.new
		@output = Array.new
		
		def initialize inp, out
			@input = inp
			@output = out
		end
		
		def debug
			@input.each{|d| puts d}
			@output.each{|d| puts d}
		end
		
		def retInput
			@input
		end
		
		def retOutput
			@output
		end
	end
	
	def inspect
		@numberRecords
		@numberInputs
		@numberOutputs
		
		@numberMiddle
		@numberIterations
		@rate
		
		@input
		@middle
		@output
		
		@errorMiddle
		@errorOut
		
		@thetaMiddle
		@thetaOut
		
		@matrixMiddle
		@matrixOut
		
		self
	end
	
	def initialize
		@numberRecords = nil
		@numberInputs = nil
		@numberOutputs = nil
		
		@numberMiddle = nil
		@numberIterations = nil
		@rate = nil
		
		@input = Array.new
		@middle = Array.new
		@output = Array.new
		
		@errorMiddle = Array.new
		@errorOut = Array.new
		
		@thetaMiddle = Array.new
		@thetaOut = Array.new
		
		@matrixMiddle = nil
		@matrixOut = nil
		
		loadTrainingData("./train.txt")
		setParameters(5, 10000, 2376, 0.6)
		train()
		testData("./test.txt")
		
	end
	
	def train
		#@numberIterations.times do |x|
			@numberRecords.times do |y|
				forwardCalculation(@@records[y].retInput, false)
				backwardCalculation(@@records[y].retOutput)
			end
		#end
	end
	
	def backwardCalculation trainingOutput
		@numberOutputs.times do |o|
			out = @output[o].to_f
			dev = (1-out).to_f
			tr = (trainingOutput[o].to_f-out)
			
			@errorOut[o] = out*dev*tr
		end
		
		@numberMiddle.times do |m|
			sum = 0
			
			@numberOutputs.times do |o|
				mout = @matrixOut[m][o].to_f
				eout = @errorOut[o].to_f
				
				sum += mout*eout
			end
			
			mid = @middle[m].to_f
			dev = 1-mid
			
			@errorMiddle[m] = mid*dev*sum
		end
		
		@numberMiddle.times do |m|
			@numberOutputs.times do |o|
				@matrixOut[m][o] += @rate*@middle[m]*@errorOut[o].to_f
			end
		end
		
		@numberInputs.times do |i|
			@numberMiddle.times do |m|
				inp = @input[i].to_f
				emid = @errorMiddle[m].to_f
				@matrixMiddle[i][m] = @rate*inp*emid
			end
		end
		
		@numberOutputs.times do |o|
			@thetaOut[o] += @rate*@errorOut[o].to_f	
		end
		
		@numberMiddle.times do |m|
			@thetaMiddle[m] += @rate*@errorMiddle[m].to_f
		end
	end
	
	def forwardCalculation trainingInput, det
		@input = Array.new
		trainingInput.each{|x| @input.push(x) }
		
		@numberMiddle.times do |m|
			sum = 0
			
			@numberInputs.times do |i|
				inp = @input[i].to_f
				mid = @matrixMiddle[i][m].to_f
				sum += inp*mid
			end
			
			sum += @thetaMiddle[m]
			
			@middle[m] = 1/(1 + Math.exp(-sum))
			#puts sum.to_s
			
		end
		@numberOutputs.times do |o|
			sum = 0
			
			@numberMiddle.times do |m|
				mid = @middle[m].to_f
				out = @matrixOut[m][o]
				sum += mid*out
			end
			
			sum += @thetaOut[o]
			#puts sum
			@output[o] = 1/(1 + Math.exp(-sum))
		end
		@output
	end
	
	def forwardCalculationTwo trainingInput, det
		@input = Array.new
		trainingInput.each{|x| @input.push(x) }
		
		v = 3
		
		@numberMiddle.times do |m|
			sum = 0
			
			@numberInputs.times do |i|
				inp = @input[i].to_f
				mid = @matrixMiddle[i][m].to_f
				sum += inp*mid
				
			end
			
			sum += @thetaMiddle[m]
			
			@middle[m] = 1/(1 + Math.exp(-sum))
			
		end
		
		puts @thetaMiddle.to_s
		@numberOutputs.times do |o|
			sum = 0
			
			@numberMiddle.times do |m|
				mid = @middle[m].to_f
				out = @matrixOut[m][o]
				sum += mid*out
			end
			sum = sum*100
			sum += @thetaOut[o]
			#puts sum
			@output[o] = 1/(1 + Math.exp(-sum))
		end
		@output
	end
	
	
	def setParameters numberMiddle, numberIterations, seed, rate
		@numberMiddle = numberMiddle
		@numberIterations = numberIterations
		@seed = seed
		@rate = rate
		
		rn = Random.new()
		v = 1000
		ras = Array.new
		v.times do |x|
			c = rn.rand()
			ras.push(c)
		end
		ras.shuffle
		
		@input = Array.new(@numberInputs)
		@middle = Array.new(@numberMiddle)
		@output = Array.new(@numberOutputs)
		
		@errorMiddle = Array.new(@numberMiddle)
		@errorOut = Array.new(@numberOutputs)
		
		@thetaMiddle = Array.new(@numberMiddle)
		@numberMiddle.times do |n| 
			num = 2*ras.pop()-1
			@thetaMiddle[n] = num
		end
		
		@thetaOut = Array.new(@numberOutputs)
		@numberOutputs.times do |n|
			num = 2*ras.pop()-1
			@thetaOut[n] = num
		end
		
		@matrixMiddle = Array.new(@numberInputs) { Array.new(@numberMiddle)}
		@numberInputs.times do |r|
			@numberMiddle.times do |c|
				@matrixMiddle[r][c] = 2*ras.pop()-1
			end
		end
		
		@matrixOut = Array.new(@numberMiddle) { Array.new(@numberOutputs)}
		@numberMiddle.times do |r|
			@numberOutputs.times do |c|
				@matrixOut[r][c] = 2*ras.pop()-1
			end
		end
		
	end
	
	
	def testData testFile
		testLines = Array.new
		
		lines = File.open(testFile).to_a
		fstLine = lines.first
		fstLine = fstLine.lstrip
		fstLine = fstLine.rstrip
		
		numRecs = fstLine.to_i
		
		File.readlines(testFile).each do |line|
			line = line.lstrip
			line = line.rstrip
			if(line != fstLine && line.length > 0 && line != nil && line != "")
				testLines.push(line)
			end
		end
		
		testLines.each do |ln|
			inpArr = Array.new
			inpArr = ln.split(" ")
			
			outArr = Array.new
			outArr = run(inpArr)
			
			outArr.each{ |x| puts x}
		end
	end
	
	def run inp
		v = Array.new
		v = forwardCalculationTwo(inp, true)
	end
	
	def loadTrainingData trainingFile
		allLines = Array.new
		
		lines = File.open(trainingFile).to_a
		fstLine = lines.first
		fstLine = fstLine.lstrip
		fstLine = fstLine.rstrip
		
		data = fstLine.split
		@numberRecords = data[0].to_i
		@numberInputs = data[1].to_i
		@numberOutputs = data[2].to_i
		@numberOutputs = data[2].to_i
		
		File.readlines(trainingFile).each do |line|
			line = line.lstrip
			line = line.rstrip
			if(line != fstLine && line.length > 0 && line != nil && line != "")
				allLines.push(line)
			end
		end
		
		allLines.each{ |ln|
			tempIn = Array.new
			tempOut = Array.new
			
			ins = ln.split(" ", @numberInputs+1)
			
			i = 0
			while i < @numberInputs do
				tempIn.push(ins[i])
				i += 1
			end
			
			outs = ins[@numberInputs].split(" ")
			
			i = 0
			while i < @numberOutputs do
				tempOut.push(outs[i])
				i += 1
			end
			
			
			rec = Record.new(tempIn, tempOut)
			@@records.push(rec)
		}
	end
end