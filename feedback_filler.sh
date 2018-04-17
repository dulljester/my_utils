regex="B00([0-9]+)"
title="ID		Name		Userid"

for d in $(ls .); do
	if [[ -d $d ]]; then
		if [ $d != "sandbox" ] && [ $d != "names" ] && [ $d != "feedback" ]; then
			echo "working on "$d"..."
			newdir=./$d/
			cp ./sandbox/*.class $newdir
			cd $newdir
			echo "Feedback for "`cat names.txt`
			while IFS= read -r line; do
				echo $line
				csid=""
				seeking=`echo $line | cut -f1 -d" "`
				banner=""
				while IFS= read -r f; do
					num=`echo $f | cut -f1 -d" "`
					csid=`echo $f | cut -f2 -d" "`
					if [[ $num =~ $regex ]]; then
						number="B00"${BASH_REMATCH[1]}
						if [ $number == $seeking ]; then
							echo "CSID found: "
							banner=$number
							break
						fi
					fi
				done < "../names/db.txt"
				if [ $banner != "" ]; then
					fname="../feedback/$csid"
					echo $title > $fname
					echo $line"	"$csid >> $fname
					java Processor < sk.txt >> $fname
					java Report < sj.txt >> $fname
				else
					echo "not found for "$line
				fi
			done < "names.txt"
			cd ..
		fi
	fi
done
