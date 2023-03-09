#!/bin/sh

# take in commit ID as arg
COMMIT_ID=$1
echo "Checking out to $COMMIT_ID"

# Checkout the repository to that commit
git checkout $COMMIT_ID
CHECKOUT_RES=$?
if [[ "$CHECKOUT_RES" -eq 0 ]]; then
  echo "Checkout successful"
else
  echo "Checkout failed"
  exit 1
fi

IMAGE_NAME="maven-image"

# Rebuild the Dockerfile image
echo "Building the docker image: $IMAGE_NAME"
docker build . -t $IMAGE_NAME
build_result=$( docker images -q $IMAGE_NAME )
if [[ -n "$build_result" ]]; then
  echo "$IMAGE_NAME image built successfully"
else
  echo "$IMAGE_NAME image build failed"
  echo $build_result
  exit 1
fi

# Create a temporary container and execute the build within it to obtain the build result
echo "executing the container"
docker run --rm $IMAGE_NAME
run_result=$?
# check result
if [[ "$run_result" -eq 0 ]]; then
  echo $run_result
  echo 'clean' > mvn-$COMMIT_ID.txt
else
  echo 'broken' > mvn-$COMMIT_ID.txt
fi

