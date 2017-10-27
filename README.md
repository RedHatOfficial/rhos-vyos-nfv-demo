rhos-vyos-nfv-demo Quickstart Guide
============================================================
NFV Demo based on Red Hat OpenStack product.

This demo will install the Opensource Network Appliance VyOS (https://vyos.io) in
your Openstack environment and utilize it as a router to route between your External
Provider Network and a Private Tenant Network to demonstrate NFV on Openstack.

This demo uses Ansible for configuration and deployment, however, we did not make use
of the Openstack Modules for Ansible.  Using these modules requires the installation
of the Shade libraries which are not installed by default on Director. We did not want to
modify an existing Director as part of the demo so it could be performed on a deployment at
a customer site if needed.

Pre-requisites
--------------

The following pre-requisites must be met prior to executing the demo:

  - An external provider network must exist and the network name must be unique
  - An internal tenant network must exist and the network name must be unique
  - Configure the variables.yaml file in the ./ansible directory
  - IMPORTANT: Git Large File System (LFS) is required since this repository contains 2 qcow2
    image files which make up the VyOS appliance and Cirros for the test VM. You can check
    if Git LFS is installed by typing "git lfs status" and if it is installed, you will get a message
    stating: "Not in a git repository.".  If you get something other than that, you must install Git
    LFS prior to cloing.
  - Clone this repository with:
      git lfs clone https://github.com/redhatdemocentral/rhos-vyos-nfv-demo

Setup and Configuration
-----------------------

In the ./ansible sub-directory, view and update the variables.yaml file for your environment.

The file is well documented in regards to the configurable settings.  Ensure the settings
match your environment.

Once this file is configured, simply run 'init.sh' to start the deployment.

Supporting articles
-------------------

See Mojo page: https://mojo.redhat.com/groups/openstack-community-of-practice/blog/2017/10/05/delivering-nfv-on-openstack-with-vyos

GIT LFS
-------

Install git LFS:

  1. mkdir ~stack/git-lfs
  2. cd ~stack/git-lfs
  3. curl -o git-lfs-linux-amd64-2.3.4.tar.gz -L https://github.com/git-lfs/git-lfs/releases/download/v2.3.4/git-lfs-linux-amd64-2.3.4.tar.gz
  4. tar -zxvf git-lfs-linux-amd64-2.3.4.tar.gz 
  5. cd git-lfs-2.3.4/
  6. sudo ./install.sh
  7. git lfs install


Demo Artifacts
--------------

This Demo will create a ./run directory off of the DEMO_ROOT directory and leave a couple files
behind for review.  First, there is the user_data file which is passed to the VyOS Appliance
and used by vyos-cloudinit to configure the appliance.

The other artifacts are generated if if the playbook instantiates the VyOS appliance and virtual machine.
The playbook will also generate an additional YAML and hosts file in the ./run sub-directory that can be used 
to demonstrate use of the vyos_config Ansible module to forward port 22 from the external interface 
of the VyOS appliance to the back end Virtual Machine.

