# Docker Development Environment

## Project Components
### ```config.env```
Stores all configuration variables (user IDs, project names, etc.) in one place. This prevents hard-coding values and allows other scripts to import them.

### ```Dockerfile```
Contains the set of instructions to build the Docker image. It defines the base operating system, installs system packages and sets up the user.

### ```gen_container.sh```
A helper script that reads the ```config.env``` file and runs the ```docker build``` command. Its main purpose is to pass the environment variables as build arguments into the Dockerfile.

### ```run_container.sh```
A helper script that runs the container in an interactive session ```bash```. It reads the ```config.env``` file and sets up all necessary ```docker run``` flags.

### ```docker-compose.yaml```
A declarative file that defines the entire development service. It tells Docker Compose how to build the image (using the Dockerfile and config.env) and how to run the container, including all volumes and environment settings. It serves as an alternative to using the ```gen_container.sh``` and ```run_container.sh``` scripts


## How to Use

### With ```.sh``` scripts
1. Build the image - docker build
    ```bash
    ./gen_container.sh
    ```

2. Execute the container using the created image - docker run
    ```bash
    ./run_container.sh
    ```

3. Close and remove container
    ```bash
    exit
    ```

### With ```docker-compose.yaml```
1. Build the image and execute the container
    ```bash
    docker-compose up -d --build
    ```

2. Get into the terminal bash
    ```bash
    docker exec -it devcontainer bash
    ```

3. Close and remove container
    ```bash
    docker-compose down
    ```
