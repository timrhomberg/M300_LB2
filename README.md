# M300_LB2

Dockerfile
----------

![](Konzept.jpg)
Als image verwendete ich die aktuellste Version von Ubuntu.
```
FROM ubuntu:16.04
```

Container starten
-----------------

```
docker build -t webmin .
docker run --rm -d --name webmin5 webmin5 --network="bridge"
```



docker exec -it webmin bash
