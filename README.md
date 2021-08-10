# Frappe Vagrant Box
A vagrant box that uses `hashicorp/bionic64` box.
This box is useful to develop Frappe apps.

## Prerequisites
Make sure that you have
**[Vagrant which can be downloaded from here](https://www.vagrantup.com/)**.

The *Vagrant virtual machine* is setup to use
**[VirtualBox and can be downloaded from here](https://www.virtualbox.org/wiki/Downloads)**.
Other virtual machines can be used but follow instructions on
**[the installation docs here](https://www.vagrantup.com/docs/installation)**.

If you have never used **Vagrant** check the tutorials on
**[the tutorials page here](https://learn.hashicorp.com/vagrant)**.

## Initialization and Setup
The file for initializing the vagrant setup is `init.sh` for Linux machines and `init.bat` for Windows machines.
Ensure that the files are executable to continue.
Run the appropriate file for your Operating System to initialize the vagrant installation.

Setup **Vagrant Variables** in the file `Vagrant.yaml`,
which is a copy of `Vagrant.yaml.example`.
The file is generated after running `init.sh` or `init.bat`.

Bring Up the **Vagrant Virtual Machine** using the command `vagrant up` and then
open a SSH to the **Vagrant Virtual Machine** using the command `vagrant ssh`.

## Provisioning
The features provisioned are:
- `Nginx` web server
- `Git` version control
- `Redis` in-memory data structure store
- `Node.js` back-end JavaScript runtime environment
- `Python` programming language interpreter
- `wkhtmltopdf` HTML into PDF rendering engine
- `Bench CLI` Multi-tenant platform to install and manage Frappe apps
