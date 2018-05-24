BEGIN {
  RS = "\n"
  FS = "href="
}
NF > 1 {
    for(i = 2; i <= NF; i+=2) {
	gsub(/["']/, "", $i)
	gsub(/[> ].*/, "", $i)
	print $i
    }
}
