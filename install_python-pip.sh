#	python env  
#!/bin/bash

function check_ok {
	if  [ $? -ne 0 ]; then
		printf "sorry, something wrong happen\n"
		exit
}

#	archive  latest pip script	
wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
check_ok

python get-pip.py
check_ok

#	install some libs

pip install pandas
check_ok

pip install scipy
check_ok

yum install -y python-devel
pip install matplotlib
check_ok
