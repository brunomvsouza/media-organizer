# Photo Organizer

A small command line tool created to organize photos and videos of a given source path to a destination path on /year/month/20071119T083748-0600_md5md5m.ext format.
For photos it uses EXIF photo creation date with a fallback to mdate to create the new file path. For videos it just uses mdate to create the new file path.

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
ruby video_organizer.rb /path/to/source/dir /path/to/destination/dir
```

## Known bugs

Unfortunately there no standalized way to store photo's capture date and time on EXIF data what causes some issues on creating file names of some camera vendors.

