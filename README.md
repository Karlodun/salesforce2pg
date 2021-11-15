# simlpe-salesforce-postgres
Automatic, timed data Sync from salesforce to PostgreSQL using, simple-salesforce

The tool consists of
* PostgreSQL sql setup script - execute this first, adopt if required
* sample sql script to fill the configs in PostgreSQL - adopt and extend where required
* sf.py file which provides the Salesforce connection cursor.
* pg.py file which provides the PostgreSQL connection cursor. Adopt your pg_hba.conf as suggested below or adopt the postgresql credentials there.
* sync.py - python script to migrate the data
* salesforce_sync.service/.timer - systemd service and timer files
The scripts are created in a way to be managed by SystemD directly, which takes care about keeping them alive, restarting on timer, tracking status of sync.
Check 

Setup:
# setup scripts
* execute setup.sql in postgres, check if you need to adopt anything
* adopt and execute sample_config.sql

# copy Files

copy all files to directory, which is configured in systemd service. predefined directory is: /etc/var/salesforce_sync/

# SystemD Timer
* please google for instal instructions of systemd services and timers for your distro, please fix the path in service file according to your requirements
* enable the timer ex: systemctl enable salesforce_sync.timer;
* start the timer, ex: systemctl start salesforce_sync.timer;

[component overview](Karlodun.github.com/salesforce2pg/component%20overview.png)

[functions and tables](Karlodun.github.com/salesforce2pg/functions%20and%20tables.pdf)
