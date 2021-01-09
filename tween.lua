local socket = require "socket"
local _nextId = 0

local nextId = function() 
	_nextId = _nextId + 1
	return _nextId
end

local TweenGroups = {}
local Groups_mt = {__index = TweenGroups}

function TweenGroups:add(group)
	self._groups[group:getId()] = group
end

function TweenGroups:remove(group)
	self._groups[group:getId()] = nil
end

function TweenGroups:update(time, preserve)
	for k ,v in pairs(self._groups) do
		v:update(time, preserve)
	end
end

function TweenGroups.new()
	return setmetatable(
	{
		_groups = {},
	}, Groups_mt)
end

tweenGroups = TweenGroups.new()

tween =
{
}

local pow, sin, cos, pi, sqrt, abs, asin = math.pow, math.sin, math.cos, math.pi, math.sqrt, math.abs, math.asin

-- linear
local function linear(k)
	return k 
end

-- quad
local function inQuad(k) return k * k end

local function outQuad(k)
	return k * (2 - k)
end

local function inOutQuad(k)
	k = k * 2
	
	if k < 1 then
		return 0.5 * k * k
	end

	k = k - 1
	return - 0.5 * (k * (k - 2) - 1)
end

-- cubic
local function inCubic (k) return k * k * k end

local function outCubic(k) 
	k = k - 1
	return k * k * k + 1
end

local function inOutCubic(k)
	k = k * 2
	
	if k < 1 then
		return 0.5 * k * k * k
	end
	
	k = k - 2
	
	return 0.5 * (k * k * k + 2)
end

-- quart
local function inQuart(k) return k * k * k * k end

local function outQuart(k) 
	k = k - 1
	return 1 - (k * k * k * k)
end

local function inOutQuart(k)
	k = k * 2
	
	if k < 1 then
		return 0.5 * k * k * k * k
	end

	k = k - 2
	return - 0.5 * (k * k * k * k - 2)
end

-- quint
local function inQuint(k) return k * k * k * k * k end

local function outQuint(k)
	k = k - 1
	return k * k * k * k * k + 1
end

local function inOutQuint(k)
	k = k * 2
	
	if k < 1 then
		return 0.5 * k * k * k * k * k
	end

	k = k - 2
	return 0.5 * (k * k * k * k * k + 2);
end

-- sine
local function inSine(k) return 1 - cos(k * pi / 2) end

local function outSine(k) return sin(k * pi / 2) end

local function inOutSine(k) return 0.5 * (1 - cos(pi * k)) end

-- expo
local function inExpo(k)
	if k == 0 then
		return 0
	end
	
	return pow(1024, k - 1)
end

local function outExpo(k)
	if k == 1 then
		return 1
	end
	
	return 1 - pow(2, - 10 * k)
end

local function inOutExpo(k)
	if k == 0 then
		return 0
	end

	if k == 1 then
		return 1
	end

	k = k * 2 
 
	if k < 1 then
		return 0.5 * pow(1024, k - 1)
	end

	return 0.5 * (- pow(2, - 10 * (k - 1)) + 2)
end

-- circ
local function inCirc(k) return 1 - sqrt(1 - k * k) end

local function outCirc(k)  
	k = k - 1
	return sqrt(1 - (k * k)) 
end
	
local function inOutCirc(k)
	k = k * 2
	
	if k < 1 then
		return - 0.5 * (sqrt(1 - k * k) - 1)
	end

	k = k - 2
	return 0.5 * (sqrt(1 - k * k) + 1)
end

-- elastic
local function inElastic(k)
	if k == 0 then
		return 0
	end

	if k == 1 then
		return 1
	end

	return -pow(2, 10 * (k - 1)) * sin((k - 1.1) * 5 * pi)
end

local function outElastic(k)
	if k == 0 then
		return 0
	end

	if k == 1 then
		return 1
	end

	return pow(2, -10 * k) * sin((k - 0.1) * 5 * pi) + 1
end

local function inOutElastic(k)
	if k == 0 then
		return 0
	end

	if k == 1 then
		return 1
	end

	k = k * 2

	if k < 1 then
		return -0.5 * pow(2, 10 * (k - 1)) * sin((k - 1.1) * 5 * pi)
	end

	return 0.5 * pow(2, -10 * (k - 1)) * sin((k - 1.1) * 5 * pi) + 1
end

-- back
local function inBack(k)
	local s = 1.70158
	return k * k * ((s + 1) * k - s)
end

local function outBack(k)
	local s = 1.70158
	k = k - 1
	return k * k * ((s + 1) * k + s) + 1
end

local function inOutBack(k)
	local s = 1.70158 * 1.525
	k = k * 2

	if k < 1 then
		return 0.5 * (k * k * ((s + 1) * k - s))
	end

	k = k - 2
	return 0.5 * (k * k * ((s + 1) * k + s) + 2)
end

-- bounce
local function outBounce(k)
	if k < (1 / 2.75) then
		return 7.5625 * k * k
	elseif (k < (2 / 2.75)) then
		k = k - (1.5 / 2.75)
		return 7.5625 * k * k + 0.75
	elseif (k < (2.5 / 2.75)) then
		k = k - (2.25 / 2.75)
		return 7.5625 * k * k + 0.9375
	else
		k = k - (2.625 / 2.75)
		return 7.5625 * k * k + 0.984375
	end
end

local function inBounce(k) 
	return 1 - outBounce(1 - k)
end

local function inOutBounce(k)
	if k < 0.5 then
		return inBounce(k * 2) * 0.5
	end

	return outBounce(k * 2 - 1) * 0.5 + 0.5
end

local function random(k)
	return math.random()
end

tween.easing =
{
	linear    = linear,
	inQuad    = inQuad,    outQuad    = outQuad,    inOutQuad    = inOutQuad,
	inCubic   = inCubic,   outCubic   = outCubic,   inOutCubic   = inOutCubic,
	inQuart   = inQuart,   outQuart   = outQuart,   inOutQuart   = inOutQuart,
	inQuint   = inQuint,   outQuint   = outQuint,   inOutQuint   = inOutQuint,
	inSine    = inSine,    outSine    = outSine,    inOutSine    = inOutSine,
	inExpo    = inExpo,    outExpo    = outExpo,    inOutExpo    = inOutExpo,
	inCirc    = inCirc,    outCirc    = outCirc,    inOutCirc    = inOutCirc,
	inElastic = inElastic, outElastic = outElastic, inOutElastic = inOutElastic,
	inBack    = inBack,    outBack    = outBack,    inOutBack    = inOutBack,
	inBounce  = inBounce,  outBounce  = outBounce,  inOutBounce  = inOutBounce,
	random    = random
}

local function getEasingFunction(easing)
	easing = easing or "linear"
	
	if type(easing) == 'string' then
		local name = easing
		easing = tween.easing[name]
		
		if type(easing) ~= 'function' then
			error("The easing function name '" .. name .. "' is invalid")
		end
	end
	
	return easing
end

local Tween = {}
local Tween_mt = {__index = Tween}

function Tween:getId()
	return self._id
end

function Tween:isPlaying()
	return self._isPlaying
end

function Tween:to(properties, duration)
	self._group:add(self)
	self._valuesEnd = properties
	
	for property, v in pairs(self._valuesEnd) do
		self._valuesEndBak[property] = self._valuesEnd[property]
	end
	
	if duration ~= nil then
		self._duration = duration
	end

	return self
end

function Tween:start(time)
	if self._isPause == true then
		self._pauseEndTime = socket.gettime() * 1000
		self._isPause = false
		
		if self._pauseStartTime < self._startTime then
			self._startTime = self._pauseEndTime
			self._pauseStartTime = 0
			self._pauseEndTime = 0
		end
		
		return
	end
	
	if self._isPlaying then
		return
	end
	
	self._isPlaying = true
	self._onStartCallbackFired = false

	if time ~= nil then
		if type(time) == "string" then
			self._startTime = socket.gettime() * 1000 + tonumber(time)
		else
			self._startTime = time
		end
	else
		self._startTime = socket.gettime() * 1000
	end

	self._startTime = self._startTime + self._delayTime

	for property, v in pairs(self._valuesEnd) do
		-- If `to()` specifies a property that doesn't exist in the source object,
		-- we should not set that property in the object
		if self._object[property] ~= nil then
			-- Save the starting value.
			self._valuesStart[property] = self._object[property]
			self._valuesStartBak[property] = self._object[property]
		end

		self._valuesStartRepeat[property] = self._valuesStart[property] or 0
	end

	return self
end

function Tween:pause()
	if self._isPause == true then
		return
	end
	
	self._pauseStartTime = socket.gettime() * 1000
	self._isPause = true 
end

function Tween:stop()
	self._isPlaying = false
	self._isPause = false
	
	for property, v in pairs(self._valuesStartBak) do
		self._object[property] = self._valuesStartBak[property]
		self._valuesStart[property] = self._valuesStartBak[property]
	end
	
	for property, v in pairs(self._valuesEndBak) do
		self._valuesEnd[property] = self._valuesEndBak[property]
	end
	
	self._repeat = self._repeatBak
	self._startTime = nil
	self._yoyoCount = 0

	if self._onStopCallback ~= nil then
		self._onStopCallback(self._instance, self._propertyName, self._valuesStart)
	end

	return self
end

function Tween:endEXT()
	self:update(self._startTime + self._duration)
	return self
end

function Tween:delay(amount)
	self._delayTime = amount
	return self
end

function Tween:repeatEXT(times)
	self._repeatBak = times
	self._repeat = times
	return self
end

function Tween:repeatDelay(amount)
	self._repeatDelayTime = amount
	return self
end

function Tween:yoyo(yy)
	self._yoyo = yy
	return self
end

function Tween:easing(eas)
	self._easingFunction = getEasingFunction(eas)
	return self
end

function Tween:interpolation(inter)
	self._interpolationFunction = inter
	return self
end

function Tween:chain()
	self._chainedTweens = arguments
	return self
end

function Tween:onStart(callback)
	self._onStartCallback = callback
	return self
end

function Tween:onUpdate(callback)
	self._onUpdateCallback = callback
	return self
end

function Tween:onComplete(callback)
	self._onCompleteCallback = callback
	return self
end

function Tween:onStop(callback)
	self._onStopCallback = callback
	return self
end

function Tween:onLoop(callback)
	self._onLoopCallback = callback
	return self
end

function Tween:update(time)
	local property = 0
	local elapsed = 0
	local value = 0
	
	if self._isPlaying == false then
		return true
	end

	if time < self._startTime then
		return true
	end

	if self._onStartCallbackFired == false then
		if self._onStartCallback ~= nil then
			self._onStartCallback(self._object)
		end

		self._onStartCallbackFired = true
	end

	if self._isPause == true then
		return true
	end
	
	local pauseTime = 0
	
	if self._pauseStartTime ~= 0 and self._pauseEndTime ~= 0 then
		pauseTime = self._pauseEndTime - self._pauseStartTime
	end
	
	elapsed = (time - self._startTime - pauseTime) / self._duration
	elapsed = (self._duration == 0 or elapsed > 1) and 1 or elapsed

	value = self._easingFunction(elapsed)

	for property, v in pairs(self._valuesEnd) do
		-- Don't update properties that do not exist in the source object
		if self._valuesStart[property] ~= nil then
			local startValue = self._valuesStart[property] or 0
			local endValue = self._valuesEnd[property]

			-- Protect against non numeric properties.
			if type(endValue) == 'number' then
				self._object[property] = startValue + (endValue - startValue) * value;
				local max = self._valuesStartBak[property]
				local min = self._valuesEndBak[property]
				
				if max < min then
					local t = max
					max = min
					min = t
				end
				
				if self._object[property] > max then
					self._object[property] = max
				end
					
				if self._object[property] < min then
					self._object[property] = min
				end
			end
		end
	end

	if self._onUpdateCallback ~= nil then
		self._onUpdateCallback(self._instance, self._propertyName, self._object)
	end

	if elapsed == 1 then
		self._pauseStartTime = 0
		self._pauseEndTime = 0
		self._yoyoCount = self._yoyoCount + 1
		
		if self._repeat == "Infinity" or self._repeat > 0 then
			if self._repeat ~= "Infinity" then
				self._repeat = self._repeat - 1
			end

			-- Reassign starting values, restart by making startTime = now
			for property, v in pairs(self._valuesStartRepeat) do
				if type(self._valuesEnd[property]) == 'string' then
					self._valuesStartRepeat[property] = self._valuesStartRepeat[property] + tonumber(self._valuesEnd[property])
				end

				if self._yoyo == true then
					local tmp = self._valuesStartRepeat[property]

					self._valuesStartRepeat[property] = self._valuesEnd[property]
					self._valuesEnd[property] = tmp
				end

				self._valuesStart[property] = self._valuesStartRepeat[property]
			end

			local function LoopCallbackFun(self)
				if self._onLoopCallback ~= nil then
					local tweenIds = table.keys(self._group._tweens)
					self._group._LoopCallbackCount = self._group._LoopCallbackCount + 1
				
					if self._group._LoopCallbackCount == #tweenIds then
						self._onLoopCallback(self._object)
						self._group._LoopCallbackCount = 0
						self._isComplete = true
					end
				end
			end
			
			if self._yoyo == true then
				if self._yoyoCount == 2 then
					self._yoyoCount = 0
					LoopCallbackFun(self)
				end
			else
				LoopCallbackFun(self)
			end
				
			self._startTime = time
				
			if self._repeatDelayTime ~= nil then
				self._startTime = time + self._repeatDelayTime
			end

			return true
		else
			if self._onCompleteCallback ~= nil then
				local tweenIds = table.keys(self._group._tweens)
				self._group._CompleteCallbackCount = self._group._CompleteCallbackCount + 1
				
				if self._group._CompleteCallbackCount == #tweenIds then
					self._group._CompleteCallbackCount = 0
					self._group._isComplete = true
					self._onCompleteCallback(self._object)
					
					if self._group._isCompletePlay == true then
						self._group._isCompletePlay = false
						return nil
					end
					
					return false
				end
			end

			return false
		end
	end

	return true
end

function tween.new(instance, propertyName, object, group)
	return setmetatable(
	{
		_instance = instance,
		_propertyName = propertyName,
		_object = object,
		_valuesStart = {},
		_valuesEnd = {},
		_valuesStartRepeat = {},
		_duration = 1000,
		_repeat = 0,
		_repeatDelayTime = nil,
		_yoyo = false,
		_isPlaying = false,
		_reversed = false,
		_delayTime = 0,
		_startTime = nil,
		_easingFunction = getEasingFunction("linear"),
		_onStartCallback = nil,
		_onStartCallbackFired = false,
		_onUpdateCallback = nil,
		_onCompleteCallback = nil,
		_onStopCallback = nil,
		_onLoopCallback = nil,
		_group = group or tweenGroup.new(),
		_id = nextId(),
		_isPause = false,
		_pauseStartTime = 0,
		_pauseEndTime = 0,
		_valuesStartBak = {},
		_valuesEndBak = {},
		_repeatBak = 0,
		_yoyoCount = 0
		
	}, Tween_mt)
end

tweenGroup =
{
}

local TweenGroup = {}
local Group_mt = {__index = TweenGroup}

function TweenGroup:getId()
	return self._id
end

function TweenGroup:getAll()
	return _tweens 
end

function TweenGroup:removeAll()
	self._tweens = {}
end

function TweenGroup:add(tween)
	self._tweens[tween:getId()] = tween
	self._tweensAddedDuringUpdate[tween:getId()] = tween
end

function TweenGroup:remove(tween)
	self._tweens[tween:getId()] = nil
	self._tweensAddedDuringUpdate[tween:getId()] = nil 
end

function TweenGroup:play()
	if self._isComplete == true then
		self:Restart()
		self._isComplete = false
		self._isCompletePlay = true
		return
	end
	
	for k, v in pairs(self._tweens) do
		v:start()
	end
end

function TweenGroup:stop()
	for k, v in pairs(self._tweens) do
		v:stop()
	end
	
	self._LoopCallbackCount = 0
	self._CompleteCallbackCount = 0
	self._isComplete = false
	self._isCompletePlay = false
end

function TweenGroup:pause()
	for k, v in pairs(self._tweens) do
		v:pause()
	end
end

function TweenGroup:update(time, preserve)
	if self._isPause then
		return
	end
	
	local tweenIds = table.keys(self._tweens)
	
	if #tweenIds == 0 then
		return false
	end
	
	if time == nil then
		time = socket.gettime() * 1000
	end
	
	-- Tweens are updated in "batches". If you add a new tween during an update, then the
	-- new tween will be updated in the next batch.
	-- If you remove a tween during an update, it may or may not be updated. However,
	-- if the removed tween was added during the current batch, then it will not be updated.
	while #tweenIds > 0 do
		self._tweensAddedDuringUpdate = {}
		
		for i = 1, #tweenIds do
			local tween = self._tweens[tweenIds[i]]

			if (tween ~= nil and tween:update(time) == false) then
				tween._isPlaying = false

				if (preserve == false) then
					self._tweens[tweenIds[i]] = nil
				end
			end
		end
		
		tweenIds = table.keys(self._tweensAddedDuringUpdate)
	end
	
	return
end

local function __Play(self)
	self:play()
end

local function __Stop(self)
	self:stop()
end

local function __Pause(self)
	self:pause()
end

local function __Restart(self)
	self:Stop()
	self:Play()
end

local function __OnComplete(self, callback)
	for k, v in pairs(self._tweens) do
		v:onComplete(callback)
	end
end

local function __OnLoop(self, callback)
	for k, v in pairs(self._tweens) do
		v:onLoop(callback)
	end
end

local function __createSelfProperty()
    return 
	{
		_tweens = {},
		_tweensAddedDuringUpdate = {},
		_id = nextId(),
		_CompleteCallbackCount = 0,
		_LoopCallbackCount = 0,
		_isComplete = false,
		_isCompletePlay = false,
        Play = __Play,
		Stop = __Stop,
		Pause = __Pause,
		Restart = __Restart,
		OnComplete = __OnComplete,
		OnLoop = __OnLoop
    }
end

function tweenGroup.new()
	local group = {}
    table.merge(group, __createSelfProperty())
	return setmetatable(group, Group_mt)
end

function createTween(self, instance, tweenInfo, propertyTable)
	local group = tweenGroup.new()

	for k, v in pairs(propertyTable) do
		if instance[k] ~= nil then
			local a = {}
			
			if type(instance[k]) == "number" then
				a[k] = instance[k]
			else
				a = instance[k]
			end
			
			local tween = tween.new(instance, k, a, group)
			:onUpdate(function(instance, propertyName, propertyValue)
				if table.nums(propertyValue) == 1 then
					instance[propertyName] = propertyValue[propertyName]
				else
					instance[propertyName] = propertyValue
				end
			end)
			:onStop(function(instance, propertyName, propertyValue)
				if table.nums(propertyValue) == 1 then
					instance[propertyName] = propertyValue[propertyName]
				else
					instance[propertyName] = propertyValue
				end
			end)
			
			if tweenInfo["duration"] ~= nil then
				local b = {}
				
				if type(v) == "number" then
					b[k] = v
				else
					b = v
				end
				
				tween:to(b, tweenInfo["duration"])
			end
			
			if tweenInfo["repeatCount"] ~= nil then
				if tweenInfo["repeatCount"] <= 0 then
					tween:repeatEXT("Infinity")
				else
					tween:repeatEXT(tweenInfo["repeatCount"]-1)
				end
			end
			
			if tweenInfo["yoyo"] ~= nil then
				tween:yoyo(tweenInfo["yoyo"])
				
				if tweenInfo["yoyo"] == true and tweenInfo["repeatCount"] ~= nil then
					if tweenInfo["repeatCount"] > 0 then
						local n = tweenInfo["repeatCount"] * 2 - 1
						tween:repeatEXT(n)
					end
				end
			end
			
			if tweenInfo["easing"] ~= nil then
				tween:easing(tweenInfo["easing"])
			end
			
			if tweenInfo["delay"] ~= nil then
				tween:delay(tweenInfo["delay"])
			end
			
			if tweenInfo["repeatDelay"] ~= nil then
				tween:repeatDelay(tweenInfo["repeatDelay"])
			end
		end
	end

	tweenGroups:add(group)  
	return group
end