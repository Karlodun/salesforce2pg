# simlpe-salesforce-postgres
Automatic, timed data Sync from salesforce to PostgreSQL using, simple-salesforce

The tool consists of
* PostgreSQL sql setup script - execute this first, adopt if required
* sample sql script to fill the configs in PostgreSQL - adopt and extend where required
* pg_conn.py file which provides the PostgreSQL connection cursor. Adopt the postgresql credentials there
* sync.py - python script to migrate the data
* salesforce_sync.service - systemd service file, 

Setup:
# PostgreSQL

## initial roles

you can follow the next two steps or edit the setup.sql file and adopt the grants:

* create manually a postgresql role named salesforce_pipe to use for the tool
* GRANT salesforce_pipe to the role which you plan to use

## setup scripts
* execute setup.sql in postgres
* adopt and execute sample_config.sql

# copy Files

copy all files to directory, which is configured in systemd service. predefined directory is: /etc/var/salesforce_sync/

# SystemD Timer

* please google for instal instructions of systemd services and timers for your distro, please fix the path in service file according to your requirements
* enable the timer ex: systemctl enable salesforce_sync.timer;
* start the timer, ex: systemctl start salesforce_sync.timer;
