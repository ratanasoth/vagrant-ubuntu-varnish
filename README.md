# Create a VM with Vagrant (w/ pre-installed Ubuntu Server and Varnish)
 

[![N|Solid](https://www.vagrantup.com/assets/images/mega-nav/logo-vagrant-a7ab5898.svg)](https://www.vagrantup.com/) [![N|Solid](https://logo.clearbit.com/varnish-cache.org)](https://varnish-cache.org/) [![N|Solid](http://www.wiredzone.com/content/images/thumbs/0088205_linux-64-bit-no-media_125.jpg)](https://www.ubuntu.com/)

## Description
Create a new Virtual Machine (VM) via Vagrant, with pre-installed Ubuntu Server, Varnish as cache proxy and load balancer, with a pre-configured Varnish files.

### Requirements
You need to have installed the following: 
- [```VirtualBox```][virtualbox] (in order to create the VM)
- [```Vagrant```][vagrant] (in order to run the vagrant commands)

### Structure

The ```Vagranfile``` is the our main file, which contains all the commands that will be executed when we start or reload our Vagrant system.

The ```config``` folder contains all the necessary configuration files (e.g. Apache2 configuration file, Varnish configuration file etc.) which will be synced to the guest machine (the VM we are about to create).

The ```scripts``` folder contains all the necessary scripts in order to install our packages, update our system, restart services after we apply changes etc.

### Run for the first time
Open the terminal and navigate to the root folder of the project (where the ```Vagrantfile``` is located) and run the following command: 
```sh
$ vagrant up
```
This will start creating a new VM as described. It will take some time to download the requested box. Wait until it's finished.

In order to find the IP of the new VM (and thus Varnish's IP) we will have to SSH into our Vagrant machine. Type the following on the terminal:
```sh
$ vagrant ssh
$ ifconfig
```


### Configure Varnish
Open the ```config/default.vcl``` file on your host machine and edit the existing backend or add a new backend for load balancing. For example:
```sh
backend webServer3 {
   .host = "192.168.1.120";
   .port="80";
}
```

**Note**: If you add a new backend at the default.vcl file you have to add it to the cluster, like this:
```sh
cluster1.add_backend(webServer3);
```

**If your VM is up and running** you have to use ```vagrant reload``` on the console, in order for the new changes to be applied! Every time you make a change you have to use the above command!

**If not**, then start the VM as we described on the previous paragraph (```vagrant up```)


### Details
Here are some commands used in the ```Vagrantfile```:
- **Box selection.** The next command will create a new box with Ubuntu Server 14.04. This is a box offered by the community and the most popular of available boxes on Vagrant. You can find a list of all the Vagrant boxes [here][vagrantboxes].
```sh
    config.vm.box = "ubuntu/trusty64"
```

- **Network preferences.** The next command will create a public network (visible to other computers too), with ```en1: Wi-Fi (AirPort)``` as network interface and the IP will be assigned via ```DHCP```.

```sh
   config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)", type: "dhcp"
```

- **Sync host/guest folder.** Synced folders enable Vagrant to sync a folder on the host machine to the guest machine. With the following command we copy the ```config``` folder (which is located on the host machine) to the vagrant_data (on the guest machine, which is the VM).
```sh
    config.vm.synced_folder "./config", "/vagrant_data", run: "always"
```

- **Running script files.** With the following command we can run script files, like copy folders, installing packages etc. With the ```run: 'always'``` we specify that we want to run this script every time we run or reload our VM. For example, we don't want to install Varnish every time we run the VM, but we want it to install only once. Although, we need to check for the latest updates for our system.
```sh
    config.vm.provision :shell, path: "./scripts/varnish-apache2.sh"
    config.vm.provision :shell, path: "./scripts/update.sh", run: 'always'
```


   [virtualbox]: <https://www.virtualbox.org/>
   [vagrant]: <https://www.vagrantup.com>
   [vagrantboxes]: <https://atlas.hashicorp.com/boxes/search>

