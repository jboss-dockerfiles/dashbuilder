#!/bin/sh

# ********************************************
# UF Dashbuilder  - Docker image start script
# ********************************************

# Program arguments
#
# -c | --container-name:    The name for the created container.
#                           If not specified, defaults to "uf-dashbuilder"
# -h | --help;              Show the script usage
#

CONTAINER_NAME="uf-dashbuilder"
IMAGE_NAME="jboss/uf-dashbuilder"
IMAGE_TAG="0.3.4.Final"

function usage
{
     echo "usage: start.sh [ [-c <container_name> ] ] [-h]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --container-name ) shift
                                CONTAINER_NAME=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Check if container is already started
if [ -f docker.pid ]; then
    echo "Container is already started"
    container_id=$(cat docker.pid)
    echo "Stoping container $container_id..."
    docker stop $container_id
    rm -f docker.pid
fi

# Start the docker container
echo "Starting $CONTAINER_NAME docker container using:"
echo "** Container name: $CONTAINER_NAME"
image_dash=$(docker run -P -d --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG)
ip_dash=$(docker inspect $image_dash | grep IPAddress | awk '{print $2}' | tr -d '",')
echo $image_dash > docker.pid

# End
echo ""
echo "Server starting in $ip_dash"
echo "You can access the server root context in http://$ip_dash:8080"
echo "UF Dashbuilder is running at http://$ip_dash:8080/dashbuilder"

exit 0