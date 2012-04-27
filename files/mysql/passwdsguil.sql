use mysql;
GRANT ALL PRIVILEGES ON sguildb.* TO sguil@localhost IDENTIFIED BY "dbsguil";
GRANT FILE ON *.* to sguil@localhost;
update user set Password = OLD_PASSWORD("dbsguil") where User = "sguil";
FLUSH PRIVILEGES;
