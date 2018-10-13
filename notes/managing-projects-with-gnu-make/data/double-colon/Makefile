DIR	:=	data/double-colon

.PHONY: what-ran

$(DIR)/file-c.txt:: $(DIR)/file-a.txt
	echo "file-a was updated"

$(DIR)/file-c.txt:: $(DIR)/file-b.txt
	echo "file-b was updated"
