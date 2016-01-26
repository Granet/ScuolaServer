!#/bin/bash
user=root
password=toor
database=proftpd

while read LINE
		do
	
		mysql --user="$user" --password="$password" --database="$database" --execute="INSERT INTO ftpuser (userid, passwd, uid, gid, homedir, shell, count, accessed, modified) VALUES 
(’$LINE’, ENCRYPT(’$LINE’), 2001, 2001, ‘/var/www/$LINE’, ‘/sbin/nologin’, 0, ”, ”);"
  
  done < users.txt
