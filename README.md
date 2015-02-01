# nginx Dockerfile

Docker image for nginx. Both [mainline and stable][mainline-vs-stable] releases are supported; the `latest` tag uses the mainline nginx release per the [nginx maintainer recommendations][mainline-vs-stable].  All available tags on Docker Hub are:

| Docker Hub tag | nginx release |
|----------------|---------------|
| `latest`       | mainline      |
| `mainline`     | mainline      |
| `stable`       | stable        |
| `1.7`          | mainline      |
| `1.6`          | stable        |

Differences from the [official Docker image][official-image]:

* Enables environment variable interpolation in config files (thanks to scripts taken from [`shepmaster/nginx-template-image`][nginx-template-image])
* Provides a *stable* tag (the official Docker nginx image only provides the mainline/development version of nginx).
* Uses the Ubuntu PPA installation path, so there are some extra compiled modules available.
* Sets `worker_processes` to `auto`. This value should typically be set to the number of cores on the machine.  Because the Debian/Ubuntu installers set this at install-time to a static value equal to the detected number of cores on the machine, many Docker images get this wrong.  `auto` means nginx will attempt to detect the number of cores when nginx starts up.
* Bypass copy-on-write (COW) filesystem for `/var/cache/nginx` and `/var/log/nginx` directories.  This should result in better write performance in the locations nginx modifies.
* Change default config to read configuration from `/data` directories (see configuration section for more info).

## Basic usage

```
$ docker run -d -p 8080:80 abevoelker/nginx
$ curl -I http://localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.7.7
Date: Sun, 09 Nov 2014 03:44:27 GMT
Content-Type: text/html
Content-Length: 867
Last-Modified: Sun, 09 Nov 2014 03:38:48 GMT
Connection: keep-alive
ETag: "545ee1c8-363"
Accept-Ranges: bytes
```

or, if you prefer the stable version of nginx:

```
$ docker run -d -p 8080:80 abevoelker/nginx:stable
$ curl -I http://localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.6.2
Date: Sun, 09 Nov 2014 03:45:35 GMT
Content-Type: text/html
Content-Length: 867
Last-Modified: Sun, 09 Nov 2014 03:42:09 GMT
Connection: keep-alive
ETag: "545ee291-363"
Accept-Ranges: bytes
```

## Configuration

### sites-enabled

Site configuration files go in `/data/sites-enabled/`:

```
$ ls /tmp/sites-enabled
example.com
$ docker run -v /tmp/sites-enabled:/data/sites-enabled:ro abevoelker/nginx
```

If you need environment variable interpolation in your site configs, put the files in `/data/sites-templates` with a `.tmpl` extension and they will be copied to `/data/sites-enabled/` with the `.tmpl` extension removed.  See [`shepmaster/nginx-template-image`][nginx-template-image] for more info.

### nginx.conf

If you have a custom `nginx.conf`, just mount it to `/data/conf/nginx.conf`:

```
$ docker run -v /tmp/conf/my_nginx.conf:/data/conf/nginx.conf:ro abevoelker/nginx
```

If for some reason you don't want to store the file as `/data/conf/nginx.conf`, you'll need to change the default run command to reference it:

```
$ docker run -v /tmp/foo:/foo abevoelker/nginx nginx -c /foo/nginx.conf
```

When rolling your own config, be sure to check out the `nginx.conf` provided with this image for Docker-specific tweaks that may be helpful.  And note that if you change the base image, it may not provide the `/dev/stdout` and `/dev/stderr` special files.

### conf.d

Extra `.conf` files go in `/data/conf.d/`:

```
$ docker run -v /tmp/conf.d:/data/conf.d:ro abevoelker/nginx
```

Note that the default base `nginx.conf` is configured to only include files in this directory with the suffix `.conf`.

## Makefile

There's a Makefile with `make build` included as a shorthand for building the image.  By default it will build the mainline version of nginx; if you prefer the stable version, do `make build VERSION=stable`.

There are also `REGISTRY` and `TAG` variables available, so e.g. `make build REGISTRY=example.com TAG=foo` will build the image `example.com/abevoelker/nginx:foo`.

There's also a `make pull` included as a shorthand for pulling the image.  By default pulls the `latest` tag but you can provide your own, e.g. `make pull TAG=stable`.

## License

MIT license.

[mainline-vs-stable]: http://nginx.com/blog/nginx-1-6-1-7-released/
[official-image]: https://github.com/nginxinc/docker-nginx
[nginx-template-image]: https://github.com/shepmaster/nginx-template-image
