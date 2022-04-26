To build thir debian live system use docker:

docker run --privileged -i -v /proc:/proc     -v ${PWD}:/working_dir     -w /working_dir     debian:latest     /bin/bash build.sh
