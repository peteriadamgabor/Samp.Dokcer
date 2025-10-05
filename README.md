# SA-MP Server Deployment via Docker Container
This document details the configuration and procedure for deploying a **SA-MP 0.3.7 R2-2-1** server within a Docker container based on **Ubuntu 22.04**.

### Image Construction
The deployment requires the prior installation of the Docker engine. To construct the image, ensure the `Dockerfile` and `start.sh` are co-located, then execute the following command, assigning the tag `samp-server:latest`:

```shell
docker build -t samp-server:latest .
```

### Container Execution
Docker volumes are used to ensure the persistence of server content and configuration settings across container lifecycles; this is the recommended practice for managing customizable files.

### Standardized Execution Command
The command below provides the recommended syntax for launching the container. All instances of the `/path/to/local/` placeholder must be replaced with the absolute paths to the corresponding local server files and directories.

``` shell
docker run -d \
  -p 7777:7777 \
  --name samp-instance \
  --restart always \
  --volume /path/to/local/server.cfg:/samp03/server.cfg \
  --volume /path/to/local/filterscripts:/samp03/filterscripts \
  --volume /path/to/local/gamemodes:/samp03/gamemodes \
  --volume /path/to/local/scriptfiles:/samp03/scriptfiles \
  --volume /path/to/local/plugins:/samp03/plugins \
  samp-server:latest
```

### Parameter Analysis
- `-d`: Executes the container in detached mode (background execution).
- `-p 7777:7777`: Establishes port forwarding, exposing container port 7777 (the default SA-MP port) for external connectivity.
- `--name samp-instance`: Assigns a specific name to the container instance.
- `--restart always`: Configures the container for automatic restart following system reboots or unexpected termination.
- `--volume ...`: Links local files/directories to container paths, establishing persistent storage.
- `samp-server:latest`: Specifies the designated Docker image name and tag.

## Container Specifications
### Environment Variables

| Variable |                         Default Value                         |                    Function                   |
|:--------:|:-------------------------------------------------------------:|:---------------------------------------------:|
| samp_url | https://gta-multiplayer.cz/downloads/samp037svr_R2-2-1.tar.gz | Specifies the source URL for server software. |
|    TZ    |                        Europe/Budapest                        |             Configured time zone.             |
| APP_ROOT |                            /samp03                            |     Primary server installation directory.    |

### Networking & Operations
- **Port**: 7777/tcp is the primary network port for SA-MP communication.
- **Logging**: Server output is directed to standard output, enabling real-time log retrieval.

## Container Management
### Accessing Real-Time Logs
To monitor server output:
```shell
docker logs -f samp-instance
```

### Termination and Removal
The following commands manage the container lifecycle:

- **Termination**: Initiates graceful shutdown:
```shell
docker stop samp-instance
```

- **Removal**: Removes the container instance. Attention: Ensure data is backed up before execution.
```shell
docker rm samp-instance
```
