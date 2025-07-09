##############
# Base image #
##############
FROM ros:humble AS base

ARG AMENT_WORKSPACE_DIR="/ros_humble"

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

ENV DEBIAN_FRONTEND=dialog


#####################
# Development image #
#####################
FROM base as dev

ARG AMENT_WORKSPACE_DIR="/ros_humble"
ARG USERNAME="developer"
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

# DEV SETTINGS

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    software-properties-common \
 && add-apt-repository ppa:neovim-ppa/unstable -y \
 && apt-get update \
 && apt-get install -y \
    neovim \
    git \
    build-essential \
    curl \
    wget \
    unzip \
    ripgrep \
    ack cloc gdb htop iperf3 iputils-ping mlocate net-tools psmisc zsh python3-vcstool bear clangd sudo \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y python3-pip clang-format && \
    pip3 install black xmlformatter && \
    rm -rf /var/lib/apt/lists/*

# ros deps
RUN apt-get update \
  && apt-get install -y \
  ros-${ROS_DISTRO}-ros2-control \
  ros-${ROS_DISTRO}-ros2-controllers \
  ros-${ROS_DISTRO}-rqt-common-plugins \
  ros-${ROS_DISTRO}-rqt-robot-steering \
  ros-${ROS_DISTRO}-rqt-tf-tree \
  ros-${ROS_DISTRO}-rviz2 \
  ros-${ROS_DISTRO}-rviz2 \
  ros-${ROS_DISTRO}-gazebo-ros \
  ros-${ROS_DISTRO}-nmea-msgs \
  ros-${ROS_DISTRO}-mavros-msgs \
  ros-${ROS_DISTRO}-gazebo-ros2-control \
  ros-${ROS_DISTRO}-xacro \
  ros-${ROS_DISTRO}-cartographer-ros \
  ros-${ROS_DISTRO}-navigation2 \
  ros-${ROS_DISTRO}-nav2-bringup \
  ros-${ROS_DISTRO}-apriltag-ros \
  libmodbus-dev \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user with a UID/GID.
# This user is added to the sudo group with passwordless access.
# Also, set ownership for user's /home

RUN apt-get update \
  && apt-get install -y sudo \
  && rm -rf /var/lib/apt/lists/* \
  && addgroup --gid ${GID} ${USERNAME} \
  && adduser --disabled-password --gecos '' --uid ${GID} --gid ${GID} ${USERNAME} \
  && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chown -R ${UID}:${GID} /home/${USERNAME} \
  && chown -R ${UID}:${GID} ${AMENT_WORKSPACE_DIR}

# ----- Livox-SDK2 for using Lidar plugins -----

RUN git clone https://github.com/Livox-SDK/Livox-SDK2.git \
  &&  cd ./Livox-SDK2/ \
  &&  mkdir build \
  &&  cd build \
  &&  cmake .. && make -j \
  && sudo make install

# ----- Z SHELL -----

RUN su - ${USERNAME} -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' \
  && chsh -s /bin/zsh ${USERNAME}

RUN chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/${USERNAME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
# RUN echo "alias rc='source ~/.zshrc'" >> /home/$USERNAME/.zshrc
# RUN echo "source /opt/ros/humble/setup.zsh && source /ros_humble/install/setup.zsh" >> /home/$USERNAME/.zshrc 
# RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="cloud"/' /home/$USERNAME/.zshrc

#  --------------------------------------------



ENV DEBIAN_FRONTEND=dialog


USER ${USERNAME}
