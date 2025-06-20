# ROS 2 Humble Docker Template

## 0. Overview

This repository contains a Docker workspace template for [**ROS 2 Humble**](https://docs.ros.org/en/humble/index.html). Dependencies that are not expected to change during the course of a project are installed from Debian packages inside the Dockerfile, while proprietary dependencies that are expected to change during a project are mounted into the container and version controlled with [**`vcstool`**](https://github.com/dirk-thomas/vcstool). Only selected folders such as `dds/` and `src/` are mounted into the container so that the workspace **must** be compiled inside the container.

Here is an overview of the structure of this repository:

```bash
docker-ros2/
├── dds/                              # DDS middleware configuration
├── humble/                           # Docker and Docker-Compose configuration
│   ├── docker-compose.yml              # Base Docker-Compose file containing all the basic Docker set-up
│   ├── docker-compose-gui.yml          # Extends the base Docker-Compose file by X11-forwarding for graphic user interfaces
│   ├── docker-compose-gui-nvidia.yml   # Extends the graphic user interface Docker-Compose file with the Nvidia runtime
│   ├── docker-compose-nvidia.yml       # Extends the base Docker-Compose file with the Nvidia runtime for graphic acceleration
│   ├── docker-compose-vscode.yml       # Extends one of the other configurations with Visual Studio Code relevant settings
│   ├── Dockerfile                      # Dockerfile containing ROS 2 and the base dependencies
│   └── .env                            # Environment variables to be considered by Docker Compose
├── outside.repos   # VCS tool: configuration file for version control
├── bringup.repos   # VCS tool: configuration file for version control
├── justfile        # Just tool: Automates the initial setup process 
├── .devcontainer/  # Configuration files for containers in Visual Studio Code
└── .vscode/        # Configuration files for Visual Studio Code
```

## 1.0 Dependencies

[`docker`](https://www.docker.com/get-started/)  
[`vcstool`](http://wiki.ros.org/vcstool)  
[`Just`](https://github.com/casey/just?tab=readme-ov-file)  
  
In case you are running an Nvidia graphics cards and want to have hardware acceleration [with the `Nvidia` container runtime](https://nvidia.github.io/nvidia-container-runtime/)

## 1.1 Set-up

```
$ git clone -b outside-integration https://github.com/willian-leoni-isi/docker-ros2.git   
```

After cloning this repository you will have to update the packages inside the workspace. For version control we use [`vcstool`](http://wiki.ros.org/vcstool) and [`Just`](https://github.com/casey/just?tab=readme-ov-file) to automate the process. In order to **push the repositories** please import them with the following command:

```
$ just clone   
```

This should clone the desired repositories given inside `.repos` into your workspace.

**Network set-up**: The `ROS_DOMAIN_ID` is used for the ROS 2 DDS middleware configuration. The parameter `YOUR_IP` corresponds to the IP that you are using, in case you are running a simulation set it to `127.0.0.1` while for working with a physical robot you will have to set it to the IP assigned to the network interface used for connecting to the robot shown by `$ ifconfig` from the `net-tools` package on your computer. We use it for the DDS middleware configuration. The `ROBOT_IP` as well as the `ROBOT_HOSTNAME` are used to configure the `/etc/hosts` file as well as configuring the DDS middleware by IP. They should correspond to the IP shown by `$ ifconfig` on the robot as well as to its `$ hostname` and can be set to `127.0.0.1` and an arbitrary hostname in case of the simulation, you can look at this configuration in the `.env` file inside `humble` folder.


**User and group id**: These should be set identical to the user and group ID of the user running the container (see the output of `$ id`). On Debian system [anything below 1000 is generally reserved for system accounts](https://www.redhat.com/sysadmin/user-account-gid-uid) and the first UID `1000` is assigned to the first user of the system, which are the default  values in our set-up. In case your user and group IDs differ, adjust them.

## 2. Running

Either **run the Docker** manually with

```bash
$ docker compose -f humble/docker-compose-gui.yml up --build -d
```

For `Nvidia graphics cards` you can run:

```bash
$ docker compose -f humble/docker-compose-gui-nvidia.yml up --build -d
```

Then attach to running container with

```bash
$ docker exec -it ros2_docker bash
```

In order to use `zsh`, there's commented lines at Dockerfile that can be uncommented to set it as default shell, then run:

```bash
$ docker exec -it ros2_docker zsh
```

Inside the container, run:

```bash
$ source /opt/ros/humble/setup.bash # if using bash
$ source /opt/ros/humble/setup.zsh # if using zsh
```

Then compile with:

```bash
$ colcon build
```

Sometimes, to be able to run **graphical user interfaces** from inside the Docker you might have to type:

```bash
$ xhost +
```

on the **host system**. When using a user with the same name, user and group id as the host system this should not be necessary.

Thx to [Tobit Flatscher](https://github.com/2b-t), that's where it was based from.