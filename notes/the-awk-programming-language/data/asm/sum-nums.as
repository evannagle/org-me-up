	ld zero		# initialize to zero
	st sum		# store in sum
loop get   		# read a number
	jz done		# if j is 0, return
	add sum		# add number to sum
	st sum		# set new sum
	j loop		# repeat

done	ld sum		# load accumaltor with sum
	put		# echo
	halt		# exit

zero const 0
sum const