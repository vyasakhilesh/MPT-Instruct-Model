FROM python:3.9

# Install any needed packages specified in requirements.txt
# Download Git-LFS for the MPT model
RUN pip3 install fschat

RUN apt-get update && apt-get install -y \
    git \
    curl

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get install -y git-lfs

RUN pip3 install sentencepiece einops


# Copy the current directory contents into the container at /app
COPY . /app

# Copy start script
COPY start.sh /start.sh

# Make sure the script is executable
RUN chmod +x /start.sh

# Run the start script
CMD ["/start.sh"]

# Make port 12345 available to the world outside this container
EXPOSE 12345

