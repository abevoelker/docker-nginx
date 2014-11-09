# nginx Dockerfile

Docker image for nginx.  I created this image because the [official nginx Docker image][official-image] is kind of weak in my opinion, mainly in terms of it only using the development version of nginx and not making configuration easy.

The following tweaks have been applied to Dockerize nginx:

* Builds from the official nginx *stable* PPA (the official Docker nginx image uses the non-stable, development/mainline version of nginx!).
* Disable daemonization and log to stdout and stderr directly (standard Dockerization).
* Set `worker_processes` to `auto`. This is the number of cores that nginx will use. The Ubuntu installer will detect the amount of cores the machine has and encode that in nginx.conf by default, so by default this would be set to the number of cores of the machine that builds the Docker image (not what you want).
* Bypass copy-on-write filesystem for `/data`, `/var/www`, `/var/cache/nginx`, and `/var/log/nginx` directories.  This results in better performance from the locations that nginx needs to modify the disk.
* Change default config to read configuration from `/data` directories (see configuration section for more info).

## Basic usage

```
$ docker run -d -p 8080:80 abevoelker/nginx
a05187a086b896afed4d8f53fe523de3933682d2997d3bdf105f3678f53a3648
$ curl -I http://localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.6.2
Date: Sun, 09 Nov 2014 00:39:09 GMT
Content-Type: text/html
Content-Length: 867
Last-Modified: Sun, 09 Nov 2014 00:33:54 GMT
Connection: keep-alive
ETag: "545eb672-363"
Accept-Ranges: bytes
```

## Configuration

### sites-enabled

Site configuration files go in `/data/sites-enabled/`:

```
$ ls /tmp/sites-enabled
example.com
$ docker run -v /tmp/sites-enabled:/data/sites-enabled abevoelker/nginx
```

### nginx.conf

If you have a custom `nginx.conf`, just mount it to `/data/conf/`:

```
$ ls /tmp/conf
nginx.conf
$ docker run -v /tmp/conf:/data/conf abevoelker/nginx
```

If for some reason you don't want to call it nginx.conf or want to put it somewhere else, you'll need to change the default run command to reference it:

```
$ docker run -v /tmp/foo:/foo abevoelker/nginx nginx -c /foo/nginx.conf
```

Be sure to check out the `nginx.conf` provided with this image for Docker-specific tweaks.

### conf.d

Extra `.conf` files go in `/data/conf.d/`:

```
$ docker run -v /tmp/conf.d:/data/conf.d abevoelker/nginx
```

Note that the default base `nginx.conf` is configured to only include files in this directory with the suffix `.conf`.

## Building

There's a Makefile with `make build` included as a shorthand for building the image.  If you're using a private registry, you can do `REGISTRY=example.com make build` and the image will be tagged `example.com/abevoelker/nginx`.

There's also a `make pull` included as a shorthand for pulling the image.

## License

MIT license.

[official-image]: https://github.com/nginxinc/docker-nginx
