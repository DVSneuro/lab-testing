#!/bin/sh

N=0
SLEEPS=0
for X in `seq 50`; do
  for Y in `seq 50`; do
    let N=$N+1
    if [ $N -eq 30 ]; then
      let SLEEPS=$SLEEPS+1
      echo "${SLEEPS} -- i got to 30. time to sleep and reset"
      sleep 10s
      N=0
    fi
  done
done
