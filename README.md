This is a quick script that will pull relevant SMART data from an HDD or SSD attached to a Mac.

I wrote this because I needed to check the SMART status of a large number of spare disks in a 
short period. The script will allow you to test as many disks as you want until you exit.

## Requirements:

A Mac, with a recent version of [smartmontools](https://www.smartmontools.org/) installed. If you don't have smartmontools,
you can install it via homebrew.

## Usage: 

Clone it somewhere. Put it in your `$PATH` if you're going to make regular use of it.
```
chmod a+x drivetest.rb
drivetest.rb
```
