home=/home/ala

#sudo apt-get install ssh
#sudo apt-get install rsync
#chmod 0600 ~/.ssh/authorized_keys
#chmod 0700 ~/.ssh/

ssh-keygen -t rsa

user=ala
cd $home

while read name
do
  ssh-copy-id $user@$name
done < slaves_with_master

