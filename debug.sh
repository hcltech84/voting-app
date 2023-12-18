# Ensure svc & pod have the same label and the svc expose correct port
k get svc -o wide
k get po --show-labels

# Ensure we can lookup the service using its dns name
k run -it --image=nicolaka/netshoot dns-test --restart=Never --rm
dns-test> nslookup db
dns-test> exit

# Ensure we can access redis from remote
k run --image=redis redis-test
k exec -it redis-test -- /bin/sh
redis-test> redis-cli -h redis
redis:6379> SET bike:1 "Process 134"
redis:6379> GET bike:1
redis:6379> exit
redis-test> exit

# Ensure we can access postgres from remote
k run --image=postgres --env="POSTGRES_PASSWORD=anypass" postgres-test
k exec -it postgres-test -- /bin/sh
postgres-test>
psql -U postgres -h db -W # password: postgres
\conninfo
exit


k describe ingress ingress-nginx