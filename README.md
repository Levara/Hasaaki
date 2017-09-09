# ImageClinic - Heal your images

This is currently in very heavy alpha phase.

## Features: 
- Guetzli, Mozjpeg and libjpeg encoders for image compression
- Automatic optimization of images based on DSSIM similarity to original
- All original images stay in the repo and can be reverted if necessarry 
- PNG support using QuantPNG [TODO]
- A lot more coming 


## Usage:

### Regular usage:

Navigate to folder containing images you wish to optimize and run:

       imageclinic run path/to/folder/with/images

ImageClinic mounts your folder with images to Docker container and runs the
app. App is available at http://localhost:3000

Changing the port on which it runs is not yet implemented.

### Installation:

Dependencies: Docker and Bash

#### Docker:

Install docker on your operation system:

- For windows and mac: https://docs.docker.com/engine/installation/
- For linux install from your distro's repositories using your packet manager
  (apt, yum, pacman or whatever)

Test your docker install with:

       docker run hello-world

If docker runs sucessfully you are ready to use ImageClinic.

#### ImageClinic:

Clone the repo and navigate to it in terminal. Run:

       ./imageclinic install

ImageClinic will simlink the script to the folder of your choice (default is
/usr/local/bin).

**That's it.**

Periodically you can run:

       ./imageclinic reinstall

Which will rebuild the app from scratch, pulling down any changes to any of the
repos used in the project.


## ImageClinic development:

For development of ImageClinic itself navigate to where you cloned the repo and
run:

       imageclinic dev

ImageClinic will mount itself to the container in development mode and start
the server, so any change to the code will be visible immediately.
Also, ImageClinic will mount test_images folder so that you don't have to
provide a path for the images. 

Test images are taken from Yardstick image test suite: https://yardstick.pictures/

ImageClinic app is written in Rails. After cloning it is not necessarry to run
`bundle install` because the app is run inside the docker container. You should
not break anything if you do run bundle install, but it's better to let the
container install the bundle. 

You can still run any other rails and rake commands directly from app source
directory. The source directory is mounted directly in the container so all the
changes to the files are visible immediately to the rails server.

To restart the server simply ctrl+c previous server and run `imageclinic dev`
again.

#### Console:

       imageclinic console

If you need access to docker container you can run `imageclinic console` which
will give you bash session inside the container. Run the command from a
different terminal while `imageclinic dev` is running. Command will fail if
ImageClinic is not running. Command can be run from any directory, you don't
have to be in ImageClinic project directory.

## Projects used in this app:

TODO


## TODO: 
- Select port with command line switch
- Commit docker image for faster install

