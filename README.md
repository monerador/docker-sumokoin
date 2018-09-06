# docker-sumokoin

Run Sumokoin daemon on a Docker container...

### How to build

```sh
$ git clone https://github.com/monerador/docker-sumokoin.git
$ cd docker-sumokoin
$ docker build -t monerador/sumokoin .
```

### How to Run

```sh
$ docker volume create --name sumokoind
$ docker run -t -d -v sumokoind:/sumokoin/.sumokoin --name sumokoind --restart unless-stopped -p 127.0.0.1:19734:19734 -p 19733:19733 monerador/sumokoin
```
