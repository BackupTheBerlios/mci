#!/bin/sh

echo '#!/bin/sh' > /etc/postgresql/run
echo 'exec 2>&1' >> /etc/postgresql/run
echo "exec setuidgid _postgresql /usr/local/bin/postmaster -D /$(hostname | cut -d"." -f2-)/me/data/postgresql" >> /etc/postgresql/run

chmod 755 /etc/postgresql/run 


