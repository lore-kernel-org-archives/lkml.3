Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaGJIwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:52:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59271 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaGJIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:52:33 -0400
Message-ID: <53BE544D.7000104@pengutronix.de>
Date: Thu, 10 Jul 2014 10:52:29 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v7 04/33] net: set name assign type for names assigned
 using a static template
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <1404980258-30853-5-git-send-email-teg@jklm.no>
In-Reply-To: <1404980258-30853-5-git-send-email-teg@jklm.no>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="p4lE36Uvm3pHr8rfKi22GgQoDG4pXl6vd"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p4lE36Uvm3pHr8rfKi22GgQoDG4pXl6vd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/10/2014 10:17 AM, Tom Gundersen wrote:
> This covers the trivial case:
>=20
> alloc_netdev(_, "foo%d", NET_NAME_ENUM, _);
>=20
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> ---
>  drivers/net/can/dev.c                     | 2 +-

> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 9f91fcb..2441348 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -565,7 +565,7 @@ struct net_device *alloc_candev(int sizeof_priv, un=
signed int echo_skb_max)
>  	else
>  		size =3D sizeof_priv;
> =20
> -	dev =3D alloc_netdev(size, "can%d", NET_NAME_UNKNOWN, can_setup);
> +	dev =3D alloc_netdev(size, "can%d", NET_NAME_ENUM, can_setup);
>  	if (!dev)
>  		return NULL;
> =20

For can/dev.c:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--p4lE36Uvm3pHr8rfKi22GgQoDG4pXl6vd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlO+VE0ACgkQjTAFq1RaXHNcOgCeO4HisNnrIp0rzUB8DHz5XKFW
4hAAn1X+kNUOytY/MCzPMdcTTZ+NPVR+
=lr5p
-----END PGP SIGNATURE-----

--p4lE36Uvm3pHr8rfKi22GgQoDG4pXl6vd--
