# wait while alive
while ps -p 1410766 > /dev/null
do
echo "process alive"
sleep 10
done
python -c 'import sys; print(sys.version_info[:])'

