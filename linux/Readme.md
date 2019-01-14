### Jupyter with Fusion on Linux

Use the script fusion-spark.sh to connect fusion and jupyter
### Requirements:
0. Copy the file on the machine where Fusion is installed.
1. Have python environment ready and managed (3.x preferred 2.x will also work)
2. Install Jupyter and all the packages you would like to use e.g. sklearn,tensorflow,keras etc.
3. Open a new terminal:
  3.1 `export FUSION_HOME=/root/path/to/fusion/4.x`
  3.2 sh ./fusion-spark.sh
4.  You should have jupyter running on port 8888
5. Navigate to port localhost:8888, if you have jupyter running create a notebook and test the following line of code:  
  ```python
  df = spark.read.format("solr").load(format='solr',
                         collection="system_logs",
                         zkhost="localhost:9983/lwfusion/4.2.0-SNAPSHOT/solr",
                         flatten_multivalued='false',
                         request_handler='/select',
                         query="query:*\:*"
                         )
  df.printSchema()
  df.show(3)
  ```
6. If you see the spark df schema and some documents you are good to go!

### Notes:
1. If the collection is empty you might get an error but that's ok
2. If you are on a remote machine you will need to tunnel in to access jupyter. Even if port 8888 is opened to public ip's but jupyter has a setting which blocks it. You can google the instructions to allow jupter to accept connections from public ip's. You will have to generate jupyter config and change *ip* and *allow_origin* properties.
3. Moving forward you may not have to specify the zkhost. For full range of query support check out the Spark-Solr github project (https://github.com/lucidworks/spark-solr)