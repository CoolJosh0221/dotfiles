-- BenQ EX3410R on the RTX 4090. The generic rule keeps hot-plugged displays usable.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.monitor({
	output = "DP-3",
	mode = "3440x1440@144",
	position = "0x0",
	scale = 1,
	-- VRR only for fullscreen windows identified as video or game content.
	vrr = 3,
})
