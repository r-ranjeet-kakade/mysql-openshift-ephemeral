mpod=mysql-1-7f5j5

echo "Copying setup files into pod..."
oc cp ./customer-table-create.sql $mpod:/tmp/customer-table-create.sql
oc cp ./insert-customer-data.sql ${mpod}:/tmp/insert-customer-data.sql

echo "Creating table(s)..."
oc exec $mpod -- bash -c "mysql --user=root sampledb < /tmp/customer-table-create.sql"

echo "Importing data..."
oc exec $mpod -- bash -c "mysql --user=root < /tmp/insert-customer-data.sql"

echo "Here is your table:"
oc exec $mpod -- bash -c "mysql --user=root sampledb -e 'use sampledb; SELECT * FROM customer;'"

# Temporary fix because MySQL 8.* client isn't secure in mysqljs Nodejs module
echo "Setting user password..."
oc exec $mpod -- bash -c "mysql --user=root -e 'ALTER USER '\''userBMN'\'' IDENTIFIED WITH mysql_native_password BY '\''vRUWhkydWOKdMDLd'\'';'"

echo "Flushing privileges..."
oc exec $mpod -- bash -c "mysql --user=root -e 'FLUSH PRIVILEGES;'"
