# Photo Organizer

A small command line tool created to organize photos of a given source path to a destination path on /year/month/yyyymmddhhmm.ext format.
It uses EXIF photo creation date with a fallback to mdate to create the new file path.

### Requirements

* [rvm](https://rvm.io)

## Installation

* Install [rvm](https://rvm.io) if you didn't already
* Clone the project
* `cd` to the project's root folder and accept  .rvmrc needs (default ruby version and default gemset)
* Run `bundle install` on project's root folder to install gem dependencies

## Running

``` bash
ruby photo_organizer.rb /path/to/source/dir /path/to/destination/dir
```


