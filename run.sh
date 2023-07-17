docker run -it --rm --name=ros-bridge-suite \
--ipc=host --pid=host \
--network=host \
--env UID=$(id -u) \
--env GID=$(id -g) \
ghcr.io/rosblox/ros-rosbridge-suite:humble