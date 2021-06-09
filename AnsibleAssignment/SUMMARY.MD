###Setup Ansible in Ubuntu
````
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
ansible --version
````

###Ping localhost
````
ansible localhost -m ping
````

###Show inventory
````
ansible-inventory --list
````

###Setup Flask
````
pip install Flask
````
   