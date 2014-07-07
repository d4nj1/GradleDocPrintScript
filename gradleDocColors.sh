#!/bin/bash

if [ $# -ne 1 ]
  then
    echo "Please pass exactly one argument to this script"
    exit 1
fi

if [ ! -f $1 ]
  then
    echo "There is no file: $1"
    exit 1
fi

mimetype=$(mimetype -b $1)

if [ "$mimetype" != "application/pdf" ]
  then
    echo "Mimetype not application/pdf: $mimetype"
    exit 1
fi

tempfile="temp-$1"
printfile="print-$1"

pdftk $1 cat output $tempfile uncompress

# change code colors here
#
# background
# darkgrey to lightgrey
sed -i 's/0.24706 0.24706 0.24706 rg/0.95 0.95 0.95 rg/g' $tempfile

# values
# green to pink (eclipse groovy code)
# sed -i 's/0.51373 0.76078 0.51373 rg/1 0 1 rg/g' $tempfile
# green to darkblue (eclipse java code)
sed -i 's/0.51373 0.76078 0.51373 rg/0 0 0.55 rg/g' $tempfile

# statements
# lightorange to violet
sed -i 's/0.86667 0.76863 0.59608 rg/0.55 0 0.55 rg/g' $tempfile

# comments
# lightgrey to darkgreen
sed -i 's/0.68627 0.68627 0.68627 rg/0 0.39 0 rg/g' $tempfile

# annotations
# lightgrey to midgrey
sed -i 's/0.86667 0.86667 0.59216 rg/0.4 0.4 0.4 rg/g' $tempfile

# general text
# white to black
sed -i -n '1h;1!H;${;g;s/1 1 1 rg\nBT\n\/F3 9 Tf/0 0 0 rg\nBT\n\/F3 9 Tf/g;p;}' $tempfile

pdftk $tempfile output $printfile compress

rm $tempfile