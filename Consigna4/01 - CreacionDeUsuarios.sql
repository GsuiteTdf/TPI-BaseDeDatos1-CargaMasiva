CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'AppSecure123!';
CREATE USER 'etl_user'@'localhost' IDENTIFIED BY 'EtlSecure123!';
CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'ReportSecure123!';
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'AdminSecure123!';

GRANT 'role_app' TO 'app_user'@'localhost';
GRANT 'role_etl' TO 'etl_user'@'localhost';
GRANT 'role_report' TO 'report_user'@'localhost';
GRANT 'role_admin' TO 'admin_user'@'localhost';