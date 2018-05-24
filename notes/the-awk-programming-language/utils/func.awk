BEGIN {
    if(!fn) {
      print "No function name passed."
      print "Try `awk -f funcval.awk -v fn=<name> <file>`"
      exit
    }
    FS = ""
    RS = "\n"

    #left parenth
    if(!lpar) lpar = "("

    #right parenth
    if(!rpar) rpar = ")"

    #line number format
    if(!lf) lf = "L%4d,%4d:"

    #verbose
    verbose = verbose == "t"
}
curfile != FILENAME {
   curfile = FILENAME
   lineno = 0
   if(verbose) {
       system("echo \"F   $PWD/"curfile"\"")
   }
}
{
    lineno++
    rpattern = sprintf("%s%s", fn, lpar)
    pattern = escape_pattern(rpattern)

    while(match($0, pattern)) {
        line = sprintf(lf, lineno, RSTART)
	printf("%-15s %s", line, rpattern)

	depth = 1
	len0 = length($0)
	rsl = ptr = RSTART + RLENGTH

	while(depth && ptr < len0) {
	    char = substr($0, ptr, 1)
	    if(char == lpar) depth ++
	    else if(char == rpar) depth --
	    else printf("%s", char)
	    ptr++
	}

	printf("%s\n", rpar)
	$0 = substr(s, rsl)
    }
}

function escape_pattern(pat, safe) {
    safe = pat
    gsub(/[][^$.*?+{}\\()|]/, "\\\\&", safe)
    return safe
}
