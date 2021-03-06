# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    run.sh                                             :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tmatis <tmatis@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/19 17:49:28 by tmatis            #+#    #+#              #
#    Updated: 2021/02/23 16:55:44 by tmatis           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

openrc
service telegraf start
/etc/init.d/mariadb setup
service mariadb start
echo "CREATE DATABASE wordpress_site;" | mysql -u root && \
echo "CREATE USER 'wordpress'@'%' IDENTIFIED BY '1234';" | mysql -u root && \
echo "CREATE USER 'superuser'@'%' IDENTIFIED BY '1234';" | mysql -u root && \
echo "GRANT ALL PRIVILEGES ON *.* TO 'superuser'@'%';FLUSH PRIVILEGES;" | mysql -u root && \
echo "GRANT ALL PRIVILEGES ON wordpress_site.* TO 'wordpress'@'%';FLUSH PRIVILEGES;" | mysql -u root
mysql wordpress_site -u root < wordpress_site.sql
tail -f /dev/null
