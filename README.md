# Final project

## Steps of execution

### Step 1

Set the envioronment variables _keys.json_ base on _keys.json.example_ file.

Description:

    {
        "runner": {
            "url": "", # Github runner action .tar file
            "repo": "", # Github url repository
            "token": "", # Github access token
            "hash": "" # Github hash of .tar file
        },

        "vm_docker":{
            "node_count": 0, # Number of docker vm's
            "ram": "", # Ram quantity for each docker vm
            "cpus": "", # CPU quantity for each docker vm
            "image": "" # Image for docker vm
        },

        "vm_podman":{
            "node_count": Number of podman vm's,
            "ram": "Ram quantity for each podman vm",
            "cpus": "CPU quantity for each podman vm",
            "image": "Image for podman vm"
        }
    }

### Step 2

Raise vagrant instances

    vagrant up --provision

### Step 3

Wait until first docker vm starts run, available services are on this addresses:

- Sonarqube: http://localhost:9000
- Portainer: https://localhost:9001
- Jenkins: http://localhost:9002
- Nexus: http://localhost:9003 (Takes more time than the other services)

**NOTE**: Ports will automatically increase depending on quantity of vm's
## Extra commands

### Entering machines with vagrant

To enter docker

```shell
$ vagrant ssh docker-#
```

To enter podman

```shell
$ vagrant ssh podman-#
```

**NOTE**: # represent the number of the vm to enter

### Showing jenkis initialAdminPassword

First enter docker vm

```shell
$ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
    
