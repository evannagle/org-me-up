#!/bin/bash

books_dir="$PWD/books/"
notes_dir_root="$PWD/notes/"
scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"

read -p "Book Name: "        book_name
read -p "Author(s): "        book_authors
read -p "Date Published: "   book_date
read -p "Publisher: "        book_publisher
read -p "Book PDF: "         book_pdf
read -p "Book Tags: "        book_tags
read -p "Your Name: "        noter_name
read -p "Your Email: "       noter_email

# TODO: move this somewhere like a util library?
expand_path() {
    local path
    local -a pathElements resultPathElements
    IFS=':' read -r -a pathElements <<<"$1"
    : "${pathElements[@]}"
    for path in "${pathElements[@]}"; do
	: "$path"
	case $path in
	    "~+"/*)
		path=$PWD/${path#"~+/"}
		;;
	    "~-"/*)
		path=$OLDPWD/${path#"~-/"}
		;;
	    "~"/*)
		path=$HOME/${path#"~/"}
		;;
	    "~"*)
		username=${path%%/*}
		username=${username#"~"}
		IFS=: read _ _ _ _ _ homedir _ < <(getent passwd "$username")
		if [[ $path = */* ]]; then
		    path=${homedir}/${path#*/}
		else
		    path=$homedir
		fi
		;;
	esac
	resultPathElements+=( "$path" )
    done
    local result
    printf -v result '%s:' "${resultPathElements[@]}"
    printf '%s\n' "${result%:}"
}

book_pdf="$(expand_path $book_pdf)"
while [[ ! -e "$book_pdf" ]] ; do
    echo "PDF file note found: '$book_pdf'"
    read -p "Book PDF: " book_pdf
    book_pdf="$(expand_path $book_pdf)"
done

echo

# Get a snake-version of the book name
book_name_snake=$(echo $book_name | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-zA-Z -]//g' -e 's/ /-/g')

# Get an @tagged version of the tags
book_tags="$(echo @$book_tags | tr '[:upper:]' '[:lower:]' |  sed -e 's/ +\([a-z]\)/@\1/g') -e 's/@+/@/g'"

# Make the notes directoryg
notes_dir="$notes_dir_root$book_name_snake"
echo "mkdir -p $notes_dir"
mkdir -p "$notes_dir"

# Make the notes/data directory
echo "mkdir $notes_dir/data"
mkdir "$notes_dir/data"

# Copy the pdf to books/
book_pdf_snake="$books_dir$book_name_snake.pdf"
echo "cp "$book_pdf" "$book_pdf_snake""
cp "$book_pdf" "$book_pdf_snake"

# Generate readme.org from m4 template
m4 --define=BOOK_TITLE="$book_name" \
   --define=BOOK_AUTHORS="$book_authors" \
   --define=BOOK_DATE="$book_date" \
   --define=BOOK_PUBLISHER="$book_publisher" \
   --define=BOOK_YEAR="$book_year" \
   --define=BOOK_TAGS="$book_tags" \
   --define=NOTER_NAME="$noter_name" \
   --define=NOTER_EMAIL="$noter_email" \
   "$scripts_dir/templates/notes/readme.org.m4" > "$notes_dir/readme.org"


