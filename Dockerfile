FROM lscr.io/linuxserver/code-server:latest

# Add docker
RUN apt-get update -y
RUN apt-get install ca-certificates curl gnupg -y
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y
RUN apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
RUN usermod -aG docker abc
# COPY init /init
RUN chmod +x /init

# Add node version manager
RUN chown abc /config
USER abc
WORKDIR /config
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
COPY bashrc /config/.bashrc

# Add python
USER root
RUN apt-get install python3 -y

# Set default user to abc
ENV PUID=1000
ENV PGID=1000

