#!/bin/bash
wget https://www.ynetnews.com/category/3082 &> /dev/null # get source code

url_list1=`grep -oE https://www.ynetnews.com/article/[a-zA-Z0-9]{9}\" 3082\
| sed 's/.$//'` # create list of articles with 9 chars
url_list2=`grep -oE https://www.ynetnews.com/article/[a-zA-Z0-9]{9}\#autoplay \
3082 | sed 's/.........$//'` # create list with ending #autoplay
comb_url_list="$url_list1 $url_list2" # combine lists
url_list=`echo ${comb_url_list[*]} | tr " " "\n" | sort -u` # sort & uniq
echo $url_list | wc -w > results.csv # print number of articles
for cur_url in $url_list; 
do
	wget -O tmp_url $cur_url &> /dev/null # get temp url
	net=$(grep -o Netanyahu tmp_url | wc -w) # count Netanyahu repetitions
	gan=$(grep -o Gantz tmp_url| wc -w) # count Gantz repetitions
	if (( net==0 && gan==0 ));then # check if there are no repetitions
		echo $cur_url, - >> results.csv
	else echo $cur_url, Netanyahu, $net, Gantz, $gan >> results.csv
	fi
	rm tmp_url # delete tmp_url
done
rm 3082 

