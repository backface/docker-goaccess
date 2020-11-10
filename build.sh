#!/bin/bash

USERNAME=backface
IMAGE=goaccess

docker build --network=host -t $USERNAME/$IMAGE:latest .
