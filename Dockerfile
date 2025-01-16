FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PASSWORD=user

# Set timezone to Europe/London
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Install basic utilities, GNOME, and additional required packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    nano \
    software-properties-common \
    vino \
    openssh-server \
    net-tools \
    dconf-editor \
    ubuntu-desktop \
    ubuntu-gnome-desktop \
    gnome-terminal \
    gnome-startup-applications \
    gnome-shell \
    dbus-x11 \
    xterm \
    libnss3-tools \
    xvfb \
    x11-apps \
    && apt-get clean

WORKDIR /
COPY . /
RUN chmod +x script.sh

# Configure permissions and environment for GNOME
RUN echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /etc/dbus-1/session.d && \
    echo '<policy user="user"> <allow send_destination="*" eavesdrop="true"/> </policy>' > /etc/dbus-1/session.d/custom.conf

# Expose VNC and SSH ports
EXPOSE 5900 22

# Start services
CMD ["./script.sh"]