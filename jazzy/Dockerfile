##############
# Base image #
##############
FROM ros:jazzy AS base

ARG AMENT_WORKSPACE_DIR="/ros_docker"

WORKDIR ${AMENT_WORKSPACE_DIR}
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install \
    git \
    python3-colcon-clean \
    python3-osrf-pycommon \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get -y install \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-compressed-image-transport \
    ros-${ROS_DISTRO}-compressed-depth-image-transport \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-point-cloud-transport \
    ros-${ROS_DISTRO}-point-cloud-transport-plugins \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
 && rm -rf /var/lib/apt/lists/*

# Add additional installation instructions here...

ENV DEBIAN_FRONTEND=dialog


#####################
# Development image #
#####################
FROM base AS dev

ARG AMENT_WORKSPACE_DIR="/ros_jazzy"
ARG USERNAME="developer"
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

# you personal configuration
RUN apt-get update \
 && apt-get install -y \
    ack \
    cloc \
    gdb \
    htop \
    iperf3 \
    iputils-ping \
    net-tools \
    psmisc \
    zsh \
    curl \
    python3-vcstool \
 && rm -rf /var/lib/apt/lists/*

# outside deps
RUN apt-get update \
 && apt-get install -y \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-rqt-common-plugins \
    ros-${ROS_DISTRO}-rqt-robot-steering \
    ros-${ROS_DISTRO}-rqt-tf-tree \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-nmea-msgs \
    ros-${ROS_DISTRO}-mavros-msgs \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-cartographer-ros \
    ros-${ROS_DISTRO}-navigation2 \
    ros-${ROS_DISTRO}-nav2-bringup \
    ros-${ROS_DISTRO}-apriltag-ros \
   #  todo: add ros-gazebo-ignition
    libmodbus-dev \

 && rm -rf /var/lib/apt/lists/*

# Install additional developer tools here...

RUN apt-get update \
 && apt-get install -y sudo \
 && rm -rf /var/lib/apt/lists/* \
 # Remove user blocking UID 1000 on Ubuntu 24.04 and onwards:
 # See https://bugs.launchpad.net/cloud-images/+bug/2005129 and
 # https://github.com/devcontainers/images/issues/1056
 && userdel -r ubuntu || true \
 && addgroup --gid ${GID} ${USERNAME} \
 && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
 && chown -R ${UID}:${GID} /home/${USERNAME} \
 && chown -R ${UID}:${GID} ${AMENT_WORKSPACE_DIR}

# RUN git clone https://github.com/Livox-SDK/Livox-SDK2.git \
#   &&  cd ./Livox-SDK2/ \
#   &&  mkdir build \
#   &&  cd build \
#   &&  cmake .. && make -j \
#   && sudo make install

# ----- ZSH as default -----

RUN su - ${USERNAME} -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' \
 && chsh -s /bin/zsh ${USERNAME}
RUN chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc

#  --------------------------------------------

RUN echo >> ~/.zshrc "source /opt/ros/humble/setup.zsh"
RUN eval "$(register-python-argcomplete3 ros2)"
RUN eval "$(register-python-argcomplete3 colcon)"

ENV DEBIAN_FRONTEND=dialog


USER ${USERNAME}
