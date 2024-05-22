# Apache Pulsar playground

- Just a playground to play around with Apache Pulsar. 

## Pulsar in a container

```bash

docker run -it \
-p 6650:6650 \
-p 8080:8080 \
--mount source=pulsardata,target=/pulsar/data \
--mount source=pulsarconf,target=/pulsar/conf \
apachepulsar/pulsar:3.2.3 \
bin/pulsar standalone

--platform=linux/amd64

## If issues with metadata store:

-e PULSAR_STANDALONE_USE_ZOOKEEPER=1 \

pulsar://localhost:6650
http://localhost:8080

Using pulsar client

pip3 install pulsar-client

Run the consumer `python3 consumer.py`
Send some messages to be consumed by the producer `python3 producer.py`


## Get topic stats

`curl http://localhost:8080/admin/v2/persistent/public/default/my-topic/stats | python -m json.tool`

```

## Pulsar in docker compose

```bash

docker-compose up

web-dashboard - http://localhost:9527: pulsar-admin dashboard, showing various metrics and metadata information about the cluster

broker-admin - http://localhost:8080: access the broker REST interface

broker-service-url - pulsar//:locahost:6650: broker service URL for use with producers and consumers

```

## Pulsar raw

## Pulsar in K8s

```bash

helm repo add apache https://pulsar.apache.org/charts
helm repo update

git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart

`./scripts/pulsar/prepare_helm_release.sh \
    -n pulsar \
    -k pulsar-mini \
    -c
`

`
helm install \
    --values examples/values-minikube.yaml \
    --namespace pulsar \
    pulsar-mini apache/pulsar
`

`kubectl get pods -n pulsar`

## Pulsar admin

`bin/pulsar-admin brokers healthcheck`

## Go into pod
`kubectl exec -it -n pulsar pulsar-mini-toolset-0 -- /bin/bash`

bin/pulsar-admin tenants create apache

bin/pulsar-admin tenants list

bin/pulsar-admin namespaces create apache/pulsar

bin/pulsar-admin namespaces list apache

## create a topic test-topic with 4 partitions in the namespace apache/pulsar
bin/pulsar-admin topics create-partitioned-topic apache/pulsar/test-topic -p 4

bin/pulsar-admin topics list-partitioned-topics apache/pulsar


## Use Pulsar client to produce and consume messages
`kubectl get services -n pulsar | grep pulsar-mini-proxy`

`minikube service pulsar-mini-proxy -n pulsar`


webServiceUrl=http://127.0.0.1:61853/
brokerServiceUrl=pulsar://127.0.0.1:61854/

## Exec into pulsar mini proxy

`k exec -it -n pulsar pulsar-mini-proxy-0 -- /bin/bash`

Then sub and consume

`bin/pulsar-client consume -s sub apache/pulsar/test-topic  -n 0`

`bin/pulsar-client produce apache/pulsar/test-topic  -m "---------hello apache pulsar-------" -n 10`

## Pulsar manager

`
kubectl exec -it pulsar-mini-pulsar-manager-0 -n pulsar -- /bin/bash
CSRF_TOKEN=$(curl http://localhost:7750/pulsar-manager/csrf-token)
curl \
    -H "X-XSRF-TOKEN: $CSRF_TOKEN" \
    -H "Cookie: XSRF-TOKEN=$CSRF_TOKEN;" \
    -H 'Content-Type: application/json' \
    -X PUT http://localhost:7750/pulsar-manager/users/superuser \
    -d '{"name": "pulsar", "password": "pulsar", "description": "test", "email": "username@test.org"}'
`

## Pulsar manager UI password
`kubectl get secret pulsar-mini-pulsar-manager-secret -n pulsar -o jsonpath="{.data}" | jq -r 'to_entries|map("\(.key)=\(.value|@base64d)")|.[]'`

## Grafana UI details
`kubectl get secret pulsar-mini-grafana -n pulsar -o jsonpath="{.data}" | jq -r 'to_entries|map("\(.key)=\(.value|@base64d)")|.[]'`

`pulsar.peek.message=true` >> change this in appliaction properties
```
