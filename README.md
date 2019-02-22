# User Alpine
Base Alpine image that steps down from root into a runtime-defined non-privileged user

[![Build Status](https://ci.pcxserver.com/api/badges/PhasecoreX/docker-user-alpine/status.svg)](https://ci.pcxserver.com/PhasecoreX/docker-user-alpine)
[![Image Size](https://images.microbadger.com/badges/image/phasecorex/user-alpine.svg)](https://microbadger.com/images/phasecorex/user-alpine)

## For Developers
Simply have your image use this image as it's base image:
```
FROM phasecorex/user-alpine
```
Whatever you set as CMD in your image will be run as the user specified in the environment variables at runtime.

### Directories
There are also three directories created for your programs use:
- `/app`: Useful to store your program, or other scripts
- `/config`: Useful to have your programs config files stored. The user can easily volume mount this directory and modify config values.
- `/data`: Useful for your program to store databases or other persistence data. Again, the user can easily volume mount this directory to save persistence.

These three directories will be chowned to the specified user at start, but not recursively. It is up to the user to make sure permissions are correct inside the volume mounted folders.

### Multi-Arch
Pulling the base image will automatically pull the correct architecture for your build environment. If you need a specific architecture for your image (if you're making a multi-arch image, for example), you can pull a specific tag with one of the following suffixes:

- `-amd64`
- `-arm`
- `-arm64`

For example, `phasecorex/user-alpine:latest-arm64` will get the latest alpine image built for an arm64 device (Raspberry Pi). Additionally, the appropriate qemu static files have been included, so you do not need to include them if you're planning on building multi-arch images in an x64 build environment!

### Custom Entrypoints
This image uses an entrypoint script to do all of the setup at runtime. If your image utilizes an entrypoint script as well, you will need to prepend this images entrypoint ("user-entrypoint") to it:
```
ENTRYPOINT ["user-entrypoint", "your", "other", "commands"]
```
If you've modified the $PATH, or otherwise can't run user-entrypoint, you can use "/bin/user-entrypoint" instead.

## For Users
If you're a developer using this image, consider including this information in your images readme.

### UID/GID
Set the environment variable `PUID` as the user ID you want the process to run as.
You can also set the environment variable `PGID` to specify the group ID. It will default to the user ID.

For example:
```
docker run -it -e PUID=1000 phasecorex/user-alpine
docker run -it -e PUID=1000 -e PGID=1024 phasecorex/user-alpine
docker run -it -e PUID=0 phasecorex/user-alpine
```
If not supplied, the default `PUID` and `PGID` will be 1000.

If set manually to 0, the process will run as root.

### Timezone
You can also set a timezone that your process will run in. Simply define the `TZ` environment variable:
```
docker run -it -e TZ=America/Detroit -e PUID=1000 phasecorex/user-alpine
```
This helps with having correct times in process logs.

