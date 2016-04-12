#!/bin/bash

photo=`ls -1F /home/km/Wallpapers|sort -R|head -n1`
/usr/bin/feh --bg-scale /home/km/Wallpapers/"$photo"
