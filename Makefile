scripts_dir = ./scripts/make
books_dir = ./books/
notes_dir = ./notes/

.PHONY:	book

book:
	@"$(scripts_dir)/book/index.sh"

