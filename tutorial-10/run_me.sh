#!/bin/bash

echo "------------------------------------------------"
echo "                Setting up the VMs              "
echo "------------------------------------------------"
echo ""
vagrant up --no-provision

echo "------------------------------------------------"
echo "                  Installing Java               "
echo "------------------------------------------------"
echo ""
RECIPE_LIST=oracle_java8::default vagrant provision

echo "------------------------------------------------"
echo "                Installing Zookeeper            "
echo "------------------------------------------------"
echo ""
RECIPE_LIST=zookeeper vagrant provision
