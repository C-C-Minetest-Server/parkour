#!/bin/bash
for x in */*.lua
do
lua ../beautifly.lua $x > /tmp/be
mv /tmp/be $x
done
