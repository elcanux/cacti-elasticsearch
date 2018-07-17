Cacti Elasticsearch
===================
Inspired by [Busindre/ElasticSearch-Cacti](https://github.com/Busindre/ElasticSearch-Cacti) which is out of date with the latest version of Elasticsearch

How to install
--------------

 1. Install dependencies `apt-get install libwww-perl libjson-xs-perl`
 2. Install addon data_input_field https://forums.cacti.net/viewtopic.php?f=5&t=42802
 3. Import template `cacti_host_template_elasticsearch-*.xml` to Cacti
 4. Copy `elasticsearch.pl` to `scripts` (maybe /usr/share/cacti/site/scripts/)
 5. Make sure the owner & executable `chmod 755 elasticsearch.pl`

**IMPORTANT**: You need to recompile `spine` with `./configure --with-results-buffer=2048`.


Tested with
----------

- Cacti v0.8.8f
- Elasticsearch v5.5.6 

Samples
-------

![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/active_node.png)
![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/cluster_pending_tasks.png)
![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/cluster_shards_operations.png)
![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/cluster_status.png)
![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/node_file_system_count_read_write.png)
![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/node_file_system_size.png)
![Oups image not found](https://github.com/elcanux/cacti-elasticsearch/blob/master/examples/total_shards.png)
