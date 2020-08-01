# code-cv ![dockerhub](https://github.com/ghokun/code-cv/workflows/dockerhub/badge.svg)
Code Server Docker image for C++ development on the browser. Contains OpenCV, NLopt and R libraries.

[![dockeri.co](https://dockeri.co/image/ghokun/code-cv)](https://hub.docker.com/r/ghokun/code-cv)

This image is built for C++ development. Check Dockerfile for build settings.

## Quickstart
```shell
git clone https://github.com/ghokun/code-cv.git
cd code-cv/docker-compose
./novnc.sh ../example-cmake-project
```
- Navigate to localhost:3000 or server_ip:3000
- Cmd/Ctrl + Shift + P > Open URL > localhost:8080 or server_ip:8080 > Click vnc.html and Connect to noVNC
- Run your code

![Code Server ide with OpenCV in action!](https://raw.githubusercontent.com/ghokun/theia-cv/master/novnc.gif)

## Build
```shell
git clone https://github.com/ghokun/code-cv.git
docker build code-cv -t <your_tag_name>
```