# Set JAVA_HOME here to override the environment setting
# JAVA_HOME=

# default settings for starting pulsar broker

# Log4j configuration file
# PULSAR_LOG_CONF=

# Logs location
# PULSAR_LOG_DIR=

# Configuration file of settings used in broker server
# PULSAR_BROKER_CONF=

# Configuration file of settings used in bookie server
# PULSAR_BOOKKEEPER_CONF=

# Configuration file of settings used in zookeeper server
# PULSAR_ZK_CONF=

# Configuration file of settings used in global zookeeper server
# PULSAR_GLOBAL_ZK_CONF=

# Extra options to be passed to the jvm
PULSAR_MEM=" -Xms{{ max_heap_memory }} -Xmx{{ max_heap_memory }} -XX:MaxDirectMemorySize={{ max_direct_memory }}"

# Garbage collection options
PULSAR_GC=" -XX:+UseZGC -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch"

# Extra options to be passed to the jvm
PULSAR_EXTRA_OPTS="${PULSAR_EXTRA_OPTS} -Dio.netty.leakDetectionLevel=disabled -Dio.netty.recycler.maxCapacityPerThread=4096"

# Add extra paths to the bookkeeper classpath
# PULSAR_EXTRA_CLASSPATH=

#Folder where the Bookie server PID file should be stored
#PULSAR_PID_DIR=

#Wait time before forcefully kill the pulsar server instance, if the stop is not successful
#PULSAR_STOP_TIMEOUT=