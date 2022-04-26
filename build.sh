#!/bin/bash


apt-get update
apt-get install -y live-build patch gnupg2 binutils zstd

lb clean

lb config 

lb build
