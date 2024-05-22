import yfinance as yf
import pulsar
import json

tickerList = [ "ABT", "ABBV", "ABMD", "ACN", "ATVI", "ADBE", "AMD",
              "AAP", "AES", "AFL", "A", "APD" ]



client = pulsar.Client('pulsar://pulsartraining01:6650')

producer = client.create_producer('stock-topic-partitioned1', producer_name="producer1",
                                  initial_sequence_id=None, send_timeout_millis=0,
                                  compression_type=pulsar.CompressionType.NONE,
                                  max_pending_messages=1000, max_pending_messages_across_partitions=50000,
                                  block_if_queue_full=False, batching_enabled=False,
                                  batching_max_messages=1000, batching_max_allowed_size_in_bytes=131072,
                                  batching_max_publish_delay_ms=10,
                                  message_routing_mode=pulsar.PartitionsRoutingMode.RoundRobinDistribution,
                                  properties=None, batching_type=pulsar.BatchingType.Default)


for i in tickerList :

    historicalData = yf.Ticker(i).history(period = "1d", interval = "1d")
    historicalData['ticker'] = i
    histDataJsonRaw = historicalData.to_json(orient = "records")

    producer.send((histDataJsonRaw).encode('utf-8'), partition_key = i, sequence_id=None,
                  replication_clusters=None, disable_replication=False, event_timestamp=None,
                  deliver_at=None, deliver_after=None)

client.close()