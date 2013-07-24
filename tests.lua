kz = require("klootzak")

function ruleCheck(current, play, correct, msg, max)
	max = max or 14
	t_cur = {}
	t_play = {}
	for i,k in ipairs(current) do table.insert(t_cur, {num = k, suit="H"}) end
	for i,k in ipairs(play) do table.insert(t_play, {num = k, suit="H"}) end
	assert(correct == kz.checkPlay(t_cur, t_play, max),
		msg .. " (should be ".. string.format("%s", correct) .. ")")
end

function runRuleChecks()
	ruleCheck({}, {4}, true, "Inital one")
	ruleCheck({}, {4,4}, true, "Inital two same")
	ruleCheck({}, {4,5}, false, "Inital two different")
	ruleCheck({3}, {4}, true, "Higher single")
	ruleCheck({4}, {3}, false, "Lower single")
	ruleCheck({7,7}, {9,9}, true, "Higher double")
	ruleCheck({7,7}, {5,5}, false, "Lower double")
	ruleCheck({2,2,2,2}, {9,9,9,9}, true, "Higher quad")
	ruleCheck({7,7,7,7}, {5,5,5,5}, false, "Lower quad")
	ruleCheck({2,2,2,2}, {9,8,9,9}, false, "Higher mismatched quad")
	ruleCheck({7,7,7,7}, {3,5,5,5}, false, "Lower mismatched quad")
	ruleCheck({3}, {4,4}, false, "Different count 1to2")
	ruleCheck({3,3}, {4,4,4}, false, "Different count 2 to 3")
	ruleCheck({3}, {4,4,4}, false, "Different count 1 to 3")
	ruleCheck({3}, {4,4,4,4}, false, "Different count 1 to 4")
	ruleCheck({}, {}, true, "Successive pass")
	ruleCheck({5}, {}, true, "Pass on one")
	ruleCheck({5,5}, {}, true, "Pass on two")
	ruleCheck({5}, {14,3}, true, "Ace and single")
	ruleCheck({5}, {14,3,3}, true, "Ace and double")
	ruleCheck({5}, {14,3,4}, false, "Ace and mismatched double")
	ruleCheck({14},{14,14}, false, "One ace vs two")
	ruleCheck({3},{14}, true, "Single vs one ace")
	ruleCheck({3},{14,14}, true, "Single vs two ace")
	ruleCheck({14,14}, {14}, false, "Two ace to one Fail")
	ruleCheck({14,14}, {14,3}, false, "Two ace to one ace and single")
	ruleCheck({14,14,9}, {10}, true, "Higher single after two prev ace")
	ruleCheck({14,14,9}, {8}, false, "Two ace and single vs lower")
	ruleCheck({14,14,9}, {10}, true, "Two ace and single vs higher")
	ruleCheck({14,14,9}, {8,14}, true, "Two ace and single vs lower")
	ruleCheck({14,14,9}, {10,14}, true, "Two ace and single vs higher and ace")
	ruleCheck({14,14,9}, {8,14}, true, "Two ace and single vs higher and ace")
	ruleCheck({5}, {14, 13, 13}, true, "Single vs ace and double")
	ruleCheck({5,5}, {14, 12, 12}, false, "Double vs ace and high double")
	ruleCheck({5,5}, {14, 1, 1}, false, "Double vs ace and low double")
	ruleCheck({5}, {14, 7, 8}, false, "Single vs ace and mismatch double")
	ruleCheck({5,5}, {14, 14, 12, 12}, true, "Double vs double ace high dbl")
	ruleCheck({5,5}, {14, 14, 1, 1}, true, "Double vs double ace and low dbl")
	ruleCheck({5,5}, {14, 14, 14, 1, 1}, true, "Double vs tpl ace and low dbl")
	print("All rule checks pass.")
end

runRuleChecks()
