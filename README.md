## Install pgAdmin to CentOS

* pgAdmin from original postgresql repo
* tested on CentOS 7
* SELinux compatible

## Usage

* clone repository

```bash
git clone https://github.com/m0zgen/install-pgadmin4.git
```  

* run script
  
```bash
cd install-pgadmin4 && ./install-pg4.sh
```
* Enjoy

## Details

* pgAdmin runs on the 81 port
* after install pgAdmin available on the link:

```
http://<IP>:81/pgadmin4
```

* repository contains several scripts:
  * `./more/install-pg4-pgsql-repo.sh` - install pgAdmin from postgresql repository
  * `./install-pg4.sh` - install pgAdmin from pgAdmin repository
    
## Additional links
* https://www.pgadmin.org/download/pgadmin-4-rpm/

