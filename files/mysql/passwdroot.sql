use mysql;
update user set Password=OLD_PASSWORD("dbroot") where User = "root";
flush privileges;
