Cacti Elasticsearch
===================


How to install
--------------

 1. Install dependencies `apt-get install libwww-perl libjson-xs-perl libcache-perl`
 2. Install addon data_input_field https://forums.cacti.net/viewtopic.php?f=5&t=42802
 3. Import `xxx.xml` to Cacti
 4. Copy `elasticsearch.pl` to `scripts` (maybe /usr/share/cacti/site/scripts/)
 5. Make sure the owner & executable `chmod 755 elasticsearch.pl`

**IMPORTANT**: You need to recompile `spine` with `./configure --with-results-buffer=2048`.


Tested with
----------

- Cacti v0.8.8f
- Elasticsearch v5.5.6 

Samples
-------

SOON...
