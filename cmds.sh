#!/bin/sh

x="ls | wc"
eval $x 
y=$(eval $x)
echo $y 
