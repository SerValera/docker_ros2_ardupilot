FROM osrf/ros:humble-desktop
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

ARG UNAME=ros2
ARG USE_NVIDIA=1

# Dependencies
RUN sudo apt-get update \
    && apt-get install -y -qq --no-install-recommends \
    python-is-python3 \
    python3-pip \
    build-essential \
    ros-humble-desktop \
    apt-utils \
    byobu \
    fuse \
    git \
    libxext6 \
    libx11-6 \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libfuse-dev \
    libpulse-mainloop-glib0 \
    rapidjson-dev \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav \ 
    gstreamer1.0-gl \
    iputils-ping \
    nano \
    wget \
    lsb-release \
    sudo \
    software-properties-common \
    build-essential  \
    ccache \
    g++ \
    gdb \
    gawk \
    git \
    make \
    cmake \
    ninja-build \
    libtool \
    libxml2-dev \
    libxml2-utils \
    libxslt1-dev \
    python3-numpy \
    python3-pyparsing \
    python3-serial \
    libpython3-stdlib \
    libtool-bin \
    zip \
    default-jre \
    socat \
    ros-dev-tools \
    ros-humble-launch-pytest \
    && rm -rf /var/lib/apt/lists/*

RUN sudo pip install -U colcon-common-extensions
RUN sudo python3 -m pip install pexpect
RUN sudo pip install -U future 
RUN sudo pip install -U MAVProxy

# User
RUN adduser --disabled-password --gecos '' $UNAME
RUN adduser $UNAME sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENV HOME=/home/$UNAME
USER $UNAME

ENV DISPLAY=:0
RUN echo $DISPLAY

# ROS vars
WORKDIR $HOME
RUN echo "source /opt/ros/noetic/setup.bash --extend" >> ~/.bashrc && \
    echo "source /home/ros2/ardupilot_ros2/ardu_ws/install/setup.bash --extend" >> ~/.bashrc && \
    echo "export GZ_VERSION='harmonic'" >> ~/.bashrc

# Nvidia GPU vars
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute
RUN if [[ -z "${USE_NVIDIA}" ]] ;\
    then printf "export QT_GRAPHICSSYSTEsudo docker imagesM=native" >> /home/${UNAME}/.bashrc ;\
    else echo "Native rendering support disabled" ;\
    fi

# Add terminal commands
RUN echo "alias copy_files='sudo cp /home/ros2/ardupilot_ros2/ros2_ws/world/wadibirk.sdf /home/ros2/ardupilot_ros2/ardu_ws/src/ardupilot_gz/ardupilot_gz_gazebo/worlds'" >> ~/.bashrc