ARG ROS_DISTRO


FROM ros:${ROS_DISTRO}-ros-base AS builder


WORKDIR /colcon_ws

RUN git clone --recursive https://github.com/rosblox/px4_msgs src/px4_msgs && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+



FROM ros:${ROS_DISTRO}-ros-core

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-rosbridge-suite \
    ros-${ROS_DISTRO}-tf2-msgs \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /colcon_ws/install/px4_msgs /opt/ros/humble
