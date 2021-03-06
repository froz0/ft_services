# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    livenessprobe.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tmatis <tmatis@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/20 12:40:39 by tmatis            #+#    #+#              #
#    Updated: 2021/02/22 18:07:01 by tmatis           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

printf "NGINX STATUS: "
service nginx status &> /dev/null
nginx_ret=$?
if [ $nginx_ret != 0 ]; then
	printf "[KO]\n";
	exit 1;
else
	printf "[OK]\n";
fi

printf "SSHD STATUS: "
service sshd status &> /dev/null
sshd_ret=$?
if [ $sshd_ret != 0 ]; then
	printf "[KO]\n";
	exit 1;
else
	printf "[OK]\n";
fi

printf "TELEGRAPH STATUS: "
service telegraf status &> /dev/null
tel_ret=$?
if [ $tel_ret != 0 ]; then
	printf "[KO]\n";
	exit 1;
else
	printf "[OK]\n";
fi

exit 0;
