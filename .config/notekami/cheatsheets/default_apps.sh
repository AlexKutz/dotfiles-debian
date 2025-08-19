####; bash check if a file exists
if [[ -f /etc/resolv.conf ]]; then
   echo "/etc/resolv.conf exist"
fi


####; cut string length from left side
###; echo "Hello World" | cut -c -4
##; Hello World --> Hell
cut -c -4


