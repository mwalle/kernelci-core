#!/bin/sh

test_params=$1
ls -l /dev/rtc0
if [ $? -eq 0 ];then
	lava-test-case rtc-exist --result pass
	for i in $(seq 1 10); do
		rtcwake -d rtc0 -m mem -s 5
		if [ $? -eq 0 ];then
			lava-test-case rtcwake-mem-$i --result pass
		else
			lava-test-case rtcwake-mem-$i --result fail
		fi
	done

	if echo "${test_params}" | grep -q "freez" ; then
		for i in $(seq 1 10); do
			rtcwake -d rtc0 -m freeze -s 5
			if [ $? -eq 0 ];then
				lava-test-case rtcwake-freeze-$i --result pass
			else
				lava-test-case rtcwake-freeze-$i --result fail
			fi
		done
	fi
else
	lava-test-case rtc-exist --result fail
	echo "No real time clock found !"
fi

