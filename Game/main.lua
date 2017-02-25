display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
local BackGroundSound = audio.loadSound("MainpageSound.mp3")

--背景音樂
audio.play(BackGroundSound,{loops = -1})

composer.gotoScene("mainpage")

