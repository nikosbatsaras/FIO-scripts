#!/usr/bin/env bash

source $HOME/$(dirname "$0")/conf/config.sh

args=("$@")
directory="${args[0]}"
block_sizes=("${args[@]:1}")
bs="${block_sizes[-1]}"

str="$($FIO --version)"
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

# Parse time and percentiles of times
echo "Block Size (KB),Time (usec),50.00th (usec),70.00th (usec),90.00th (usec),99.00th (usec),99.90th (usec),99.99th (usec)" > "${directory}/time.txt"

for bs in ${block_sizes[@]}; do
	echo -n "$bs," >> "${directory}/time.txt"

	check=$(grep "clat (nsec):" "${directory}/${bs}.txt" | awk '{print $2}') 

	# Same scale, do nothing (usec)
	if [ "$check" = "" ]; then
		time=$(grep "clat (usec)" "${directory}/${bs}.txt" | awk '{print $5}' | grep -o '[0-9.]*')
		echo -n "$time," >> "${directory}/time.txt"

		time=$(grep -o '50.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		echo -n "$time," >> "${directory}/time.txt"

		time=$(grep -o '70.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		echo -n "$time," >> "${directory}/time.txt"

		time=$(grep -o '90.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		echo -n "$time," >> "${directory}/time.txt"

		time=$(grep -o '99.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		echo -n "$time," >> "${directory}/time.txt"

		time=$(grep -o '99.90th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		echo -n "$time," >> "${directory}/time.txt"

		time=$(grep -o '99.99th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		echo "$time" >> "${directory}/time.txt"
    # nsec -> usec	
	else 
		time=$(grep "clat (nsec)" "${directory}/${bs}.txt" | awk '{print $5}' | grep -o '[0-9.]*')
		res=$(echo "${time}*0.001" | bc)
		echo -n "$res," >> "${directory}/time.txt"

		time=$(grep -o '50.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		res=$(echo "${time}*0.001" | bc)
		echo -n "$res," >> "${directory}/time.txt"

		time=$(grep -o '70.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		res=$(echo "${time}*0.001" | bc)
		echo -n "$res," >> "${directory}/time.txt"

		time=$(grep -o '90.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		res=$(echo "${time}*0.001" | bc)
		echo -n "$res," >> "${directory}/time.txt"

		time=$(grep -o '99.00th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		res=$(echo "${time}*0.001" | bc)
		echo -n "$res," >> "${directory}/time.txt"

		time=$(grep -o '99.90th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		res=$(echo "${time}*0.001" | bc)
		echo -n "$res," >> "${directory}/time.txt"

		time=$(grep -o '99.99th=[( )[0-9.]*]' "${directory}/${bs}.txt" | cut -d '=' -f 2 | grep -o '[0-9]*')
		res=$(echo "${time}*0.001" | bc)
		echo "$res" >> "${directory}/time.txt"
	fi
done
