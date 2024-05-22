import pulsar

client = pulsar.Client('pulsar://localhost:6650')
producer = client.create_producer('my-topic')

for i in range(10):
    producer.send(('mo-test-message-%d' % i).encode('utf-8'))

# producer.send('Test')

client.close()