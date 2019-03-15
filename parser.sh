#!/usr/bin/env bash

args=("$@")
directory="${args[0]}"
block_sizes=("${args[@]:1}")
bs="${block_sizes[0]}"


str="$(fio --version)"
version="${str:4:1}"

if [ "$version" -eq 3 ]; then
	check=$(grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep "K")
	if [ "$check" = "" ]; then
		scale="MB"
		echo "Block Size (KB),Throughput (MB/s)" > "${directory}/out.txt"
	else
		scale="KB"
		echo "Block Size (KB),Throughput (KB/s)" > "${directory}/out.txt"
	fi
else
	check=$(grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep "K")
	if [ "$check" = "" ]; then
		scale="MB"
		echo "Block Size (KB),Throughput (MB/s)" > "${directory}/out.txt"
	else
		scale="KB"
		echo "Block Size (KB),Throughput (KB/s)" > "${directory}/out.txt"
	fi
fi

for bs in ${block_sizes[@]}; do
	echo -n "$bs," >> "${directory}/out.txt"
	if [ "$version" -eq 3 ]; then
		check=$(grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep "K")

		# MB -> KB
		if [ "$check" = "" ] && [ "$scale" = "KB" ]; then
			num=$(grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep -o '[0-9.]*')
			res=$(echo "${num}*1024" | bc)
			echo "$res" >> "${directory}/out.txt"
		# KB -> MB
		elif [ ! "$check" = "" ] && [ "$scale" = "MB" ]; then
			num=$(grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep -o '[0-9.]*')
			res=$(echo "${num}/1024" | bc)
			echo "$res" >> "${directory}/out.txt"
		# Same scale, do nothing
		else 
			grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep -o '[0-9.]*' >> "${directory}/out.txt"
		fi
	else
		check=$(grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep "K")

		# MB -> KB
		if [ "$check" = "" ] && [ "$scale" = "KB" ]; then
			num=$(grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep -o '[0-9.]*')
			res=$(echo "${num}*1024" | bc)
			echo "$res" >> "${directory}/out.txt"
		# KB -> MB
		elif [ ! "$check" = "" ] && [ "$scale" = "MB" ]; then
			num=$(grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep -o '[0-9.]*')
			res=$(echo "${num}/1024" | bc)
			echo "$res" >> "${directory}/out.txt"
		# Same scale, do nothing
		else 
			grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep -o '[0-9.]*' >> "${directory}/out.txt"
		fi
	fi
done
