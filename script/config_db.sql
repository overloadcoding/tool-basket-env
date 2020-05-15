-- Create django database
create database django_project character set utf8;

-- Create django user
create user 'django_user'@'localhost' identified by 'password';
grant all privileges on django_project.* to 'django_user'@'localhost';
flush privileges;