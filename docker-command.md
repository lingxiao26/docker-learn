```
docker rm $(docker ps -a -q -f status=exited)
```
`-q` flag, only returns the numeric IDs
`-f` filters output based on conditions provided

```
docker run -it busybox sh
```

