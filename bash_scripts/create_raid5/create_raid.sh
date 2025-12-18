# we first want to partition the drives required for raid
RESPONSE='Y'
while [[ $RESPONSE =~ ^([yY][eE][sS]|[yY])$ ]]
do
	bash create_partition.sh
	printf 'Do you want to partition another drive (Y/N)?'
	read RESPONSE
done
# Next, create the RAID5 on md0 via this command:
# sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1
# wait 30 hours..
# next, examine whether everything worked
# sudo mdadm -E /dev/sd[a-c]1
# Check that there are no failed devices
# sudo mdadm --detail /dev/md0
# mkdir /mnt/raid5
# mount /dev/md0 /mnt/raid5/
# ls -l ~/raid5/
# add to /etc/fstab file (without comment):
# /dev/md0                /mnt/raid5              ext4    defaults        0 0
# check if mount works (should say that raid5 is already mounted)
# mount -av
# save raid config so raid gets always mounted at /dev/md0
# mdadm --detail --scan --verbose >> /etc/mdadm/mdadm.conf

