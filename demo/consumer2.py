import pulsar

client = pulsar.Client('pulsar://pulsartraining01:6650', authentication=None, operation_timeout_seconds=30,
                       io_threads=1, message_listener_threads=1, concurrent_lookup_requests=50000,
                       log_conf_file_path=None, use_tls=False, tls_trust_certs_file_path=None,
                       tls_allow_insecure_connection=False, tls_validate_hostname=False)

consumer_type = pulsar.ConsumerType.KeyShared
initial_position = pulsar.InitialPosition.Latest

consumer = client.subscribe('stock-topic-partitioned1', 'training-subscription-partitioned1',
                            consumer_type = consumer_type, message_listener=None, receiver_queue_size=1000,
                            max_total_receiver_queue_size_across_partitions=50000, consumer_name="consumer2",
                            unacked_messages_timeout_ms=None, broker_consumer_stats_cache_time_ms=30000,
                            negative_ack_redelivery_delay_ms=60000, is_read_compacted=False,
                            properties=None, pattern_auto_discovery_period=60,
                            initial_position=initial_position)

while True:
    msg = consumer.receive(timeout_millis=None)
    try:
        print("Received message '{}' id='{}'".format(msg.data(), msg.message_id()))
        consumer.acknowledge(msg)
    except:
        consumer.negative_acknowledge(msg)

client.close()