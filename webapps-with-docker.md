# WEBAPPS WITH DOCKER

## static sites
```docker run --rm prakhar1989/static-site```
```
root@k8s-master1 ~/docker# docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
busybox                   latest              1c35c4412082        2 weeks ago         1.22MB
prakhar1989/static-site   latest              f01030e1dcf3        4 years ago         134MB
root@k8s-master1 ~/docker# docker run -d -P --name static-site f010
25fbd768701a43ea1041efa257c73f01679c73f36aa641ef789be421b4fc90ee
root@k8s-master1 ~/docker# docker port static-site
443/tcp -> 0.0.0.0:32768
80/tcp -> 0.0.0.0:32769
root@k8s-master1 ~/docker#
```

## docker images
