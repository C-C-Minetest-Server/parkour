#!/bin/bash
for x in */; do (cd $x && ../../update_translations/i18n.py);done
