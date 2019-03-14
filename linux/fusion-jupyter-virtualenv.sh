#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo FUSION_HOME is $FUSION_HOME

pushd $FUSION_HOME/bin >> /dev/null
. common.sh
popd >> /dev/null

AGENT=$FUSION_HOME/$AGENT
check_java
echo AGENT is $AGENT
echo JAVA is $JAVA

SPARK_HOME="$("$JAVA" -jar "$AGENT" config -p sparkHome spark-master)"
export SPARK_HOME="${SPARK_HOME}"
echo SPARK_HOME is $SPARK_HOME
spark_port="$("$JAVA" -jar "$AGENT" config -p port spark-master)"
spark_host="$("$JAVA" -jar "$AGENT" config -p address spark-master)"
export PYSPARK_SUBMIT_ARGS="--master spark://$spark_host:$spark_port pyspark-shell"
echo "Using PYSPARK_SUBMIT_ARGS=$PYSPARK_SUBMIT_ARGS"
export PYTHONPATH=$DIR:$SPARK_HOME/python/lib/py4j-0.9.zip:$SPARK_HOME/python:$SPARK_HOME/python/build:$DIR/../common:$DIR/../relevancy_tools

echo PYTHONPATH is $PYTHONPATH

# Set the PYSPARK_PYTHON variable to the appropriate virtualenv
export PYSPARK_PYTHON=/home/ubuntu/python3-virtualenv/bin/python
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --port=8888 --ip=0.0.0.0 --allow-root"
# Pass the right arguments in PYSPARK_OPTS so the virtualenv gets shipped/created at the executors.
export PYSPARK_OPTS="--conf spark.pyspark.virtualenv.enabled=true --conf spark.pyspark.virtualenv.type=native --conf spark.pyspark.virtualenv.bin.path=/home/ubuntu/python3-virtualenv/bin --conf spark.pys$

$FUSION_HOME/bin/spark-shell -pyspark \
                             $PYSPARK_OPTS \
                             --executor-memory 6g \
                             --driver-memory 6g \
                             --executor-cores 4 \
                             --total-executor-cores 4
