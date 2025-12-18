# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# We first specify the partition and save ti var
echo 'Please enter the partition name to format for raid via gdisk'
read TGTDEV
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "default" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | gdisk ${TGTDEV}
  o # clear the in memory partition table
  Y # agree to clearing drive of all partitions
  n # new partition
  p # primary partition
    # default - start at beginning of disk 
    # default, extend partition to end of disk
  fd00 # chose LINUX RAID as type
  p # print the in-memory partition table
  w # write the partition table
  Y # yes, we want to proceed
EOF  
