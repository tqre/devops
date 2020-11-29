#!/bin/bash
# Create a self-signed SSL certificate with SAN extension

DIR=secrets

openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 	\
	-nodes -config cert.conf 	\
	-out $DIR/gitlab.crt		\
	-keyout $DIR/gitlab.key		\
	-extensions req_ext

