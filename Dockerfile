ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}-ros-base AS builder

WORKDIR /colcon_ws

RUN git clone https://github.com/stereolabs/zed-ros2-interfaces.git src/zed_interfaces && \
    git clone https://github.com/rosblox/rslidar_msg.git src/rslidar_msg && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+




FROM ros:${ROS_DISTRO}-ros-core

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-rosbridge-suite \
    ros-${ROS_DISTRO}-tf2-msgs \
    ros-${ROS_DISTRO}-rosapi-msgs \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-sensor-msgs \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /colcon_ws/install/zed_interfaces /opt/ros/${ROS_DISTRO}
COPY --from=builder /colcon_ws/install/rslidar_msg /opt/ros/${ROS_DISTRO}

COPY ros_entrypoint.sh .

ENV LAUNCH_COMMAND='ros2 launch rosbridge_server rosbridge_websocket_launch.xml'

RUN echo 'alias run="su - ros --whitelist-environment=\"ROS_DOMAIN_ID\" /run.sh"' >> /etc/bash.bashrc && \
    echo "source /opt/ros/$ROS_DISTRO/setup.bash; echo UID: $UID; echo ROS_DOMAIN_ID: $ROS_DOMAIN_ID; $LAUNCH_COMMAND" >> /run.sh && chmod +x /run.sh
