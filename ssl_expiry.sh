#! /bin/sh
#
# Script that checks for a certificate validiti on the server
# issued for a specific SNI
#
# Usage:
#       ssl_expiry.sh -d nextcloud.example.com 443 -s opscloud.example.com
#       ssl_expiry.sh -d nextcloud.example.com -s opscloud.example.com
#
#
#    ssl-check.sh is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ssl-check is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with ssl-check.sh.  If not, see <http://www.gnu.org/licenses/>.

while getopts d:p:s: option
do
	case "${option}"
		in
		d) SERVER=${OPTARG};;
		p) PORT=${OPTARG};;
		s) SNI=${OPTARG};;
	esac
done

TIMEOUT=25
RETVAL=0
TIMESTAMP=`echo | date`

# If SNI is not set up then we remove -servername from openssl command
if [ -z ${SNI+x} ]
then
	# Port is not set up
	if  [ -z ${PORT+x} ]
	then
		PORT=443;
		EXPIRE_DATE=`echo | openssl s_client -connect $SERVER:$PORT 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2`	
	else
		EXPIRE_DATE=`echo | openssl s_client -connect $SERVER:$PORT 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2`
	fi
else

# If port is not set up it will default to 443 but SNI is defined
	if [ -z ${PORT+x} ]
	then
		PORT=443;
		EXPIRE_DATE=`echo | openssl s_client -connect $SERVER:$PORT -servername $SNI 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2`
	else
		EXPIRE_DATE=`echo | openssl s_client -connect $SERVER:$PORT -servername $SNI 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2`
	fi
fi

EXPIRE_SECS=`date -d "${EXPIRE_DATE}" +%s`
EXPIRE_TIME=$(( ${EXPIRE_SECS} - `date +%s` ))
if test $EXPIRE_TIME -lt 0
then
	RETVAL=0
else
	RETVAL=$(( ${EXPIRE_TIME} / 24 / 3600 ))
fi

echo ${RETVAL}
