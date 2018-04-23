Cacti Elasticsearch
===================


How to install
--------------

 1. Install dependencies `apt-get install libwww-perl libjson-xs-perl`
 2. Import `xxx.xml` to Cacti
 3. Copy `elasticsearch.pl` to `scripts` (maybe /usr/share/cacti/site/scripts/)
 4. Make sure the owner & executable `chmod 755 elasticsearch.pl`

**IMPORTANT**: You need to recompile `spine` with `./configure --with-results-buffer=2048`.


Samples
-------

SOON...
