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

Setup and Configuration
-----------------------

In the ./ansible sub-directory, view and update the variables.yaml file for your environment.

The file is well documented in regards to the configurable settings.  Ensure the settings
match your environment.

Once this file is configured, simply run 'init.sh' to start the deployment.

Supporting articles
-------------------

See Mojo page: https://mojo.redhat.com/groups/openstack-community-of-practice/blog/2017/10/05/delivering-nfv-on-openstack-with-vyos

Demo Artifacts
--------------

This Demo will create a ./run directory off of the DEMO_ROOT directory and leave a couple files
behind for review.  First, there is the user_data file which is passed to the VyOS Appliance
and used by vyos-cloudinit to configure the appliance.

The other artifacts are generated if if the playbook instantiates the VyOS appliance and virtual machine.
The playbook will also generate an additional YAML and hosts file in the ./run sub-directory that can be used 
to demonstrate use of the vyos_config Ansible module to forward port 22 from the external interface 
of the VyOS appliance to the back end Virtual Machine.

