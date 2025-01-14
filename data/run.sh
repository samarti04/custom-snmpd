#!/usr/bin/with-contenv bashio

CONFIG="/etc/snmp/snmpd.conf"

{
	echo "agentaddress  udp:161,udp6:[::1]:161"
	echo "com2sec readonly default $(bashio::config 'community')"
	echo "syslocation $(bashio::config 'location')"
	echo "syscontact $(bashio::config 'name') <$(bashio::config 'email')>"
	echo "group MyROGroup v2c readonly"
	echo "view all included .1 80"
	echo "access MyROGroup ''      any       noauth    exact  all    none   none"
} > "${CONFIG}"

bashio::log.info "Starting SNMP server..."

exec /usr/sbin/snmpd \
	-c "${CONFIG}" \
	-f \
	< /dev/null
