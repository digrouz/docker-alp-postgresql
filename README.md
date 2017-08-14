# docker-alp-postgresql
Install Postgresql into an Alpine  Linux container

![postgresql](http://media.postgresql.org/propaganda/slonik_with_black_text_and_tagline.gif)

## Description

PostgreSQL, often simply Postgres, is an object-relational database management system (ORDBMS) with an emphasis on extensibility and standards-compliance. As a database server, its primary function is to store data securely, supporting best practices, and to allow for retrieval at the request of other software applications. It can handle workloads ranging from small single-machine applications to large Internet-facing applications with many concurrent users.


http://postgresql.org/

## Usage
    docker create --name=postgres  \
      -v /etc/localtime:/etc/localtime:ro \ 
     -v <path to data>:/var/lib/postgresql/data \
      -e DOCKUID=<UID default:10014> \
      -e DOCKGID=<GID default:10014> \
      -e DOCKUPGRADE=<0|1> \
      -e POSTGRES_PASSWORD="<password>"  \
      -p 5432:5432 digrouz/docker-alp-postgresql

## Environment Variables

When you start the `postgresql` image, you can adjust the configuration of the `postgresql` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10014`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10014`.

### `DOCKUPGRADE`

This variable is not mandatory and specifies if the container has to launch software update at startup or not. Valid values are `0` and `1`. It has default value `1`.

### `POSTGRES_PASSWORD`

This environment variable is recommended for you to use the PostgreSQL image. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the `POSTGRES_USER` environment variable. In the above example, it is being set to "mysecretpassword".

### `POSTGRES_USER`

This optional environment variable is used in conjunction with `POSTGRES_PASSWORD` to set a user and its password. This variable will create the specified user with superuser power and a database with the same name. If it is not specified, then the default user of `postgres` will be used.

### `PGDATA`

This optional environment variable can be used to define another location - like a subdirectory - for the database files. The default is `/var/lib/postgresql/data`, but if the data volume you're using is a fs mountpoint (like with GCE persistent disks), Postgres `initdb` recommends a subdirectory (for example `/var/lib/postgresql/data/pgdata` ) be created to contain the data.

### `POSTGRES_DB`

This optional environment variable can be used to define a different name for the default database that is created when the image is first started. If it is not specified, then the value of `POSTGRES_USER` will be used.

### `POSTGRES_INITDB_ARGS`

This optional environment variable can be used to send arguments to `postgres initdb`. The value is a space separated string of arguments as `postgres initdb` would expect them. This is useful for adding functionality like data page checksums: `-e POSTGRES_INITDB_ARGS="--data-checksums"`.


## Notes

* The docker entrypoint will upgrade operating system at each startup. To disable this feature, just add `-e DOCKUPGRADE=0` at container creation.
