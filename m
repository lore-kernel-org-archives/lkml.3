Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3LIKmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:42:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46179 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194Ab3LIKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:42:27 -0500
Message-ID: <52A59E7A.5060605@pengutronix.de>
Date: Mon, 09 Dec 2013 11:42:02 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Sebastian Haas <dev@sebastianhaas.info>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: ems_usb: fix urb leaks on failure paths
References: <1386371435-17597-1-git-send-email-khoroshilov@ispras.ru> <52A309BE.7000602@hartkopp.net>
In-Reply-To: <52A309BE.7000602@hartkopp.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="I4qDKVnRoUFGb53Uhcgh8nCDGB5HSTIT4"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I4qDKVnRoUFGb53Uhcgh8nCDGB5HSTIT4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/07/2013 12:42 PM, Oliver Hartkopp wrote:
> Hello Alexey,
>=20
> looks better :-)

Is this an Acked-by?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--I4qDKVnRoUFGb53Uhcgh8nCDGB5HSTIT4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlKlnnsACgkQjTAFq1RaXHMFMwCdFC4gElSVIEHdFxvZKX7KvHSO
RZEAn29pRj6QNZWTmtcewwMf9adMCw+F
=6y8n
-----END PGP SIGNATURE-----

--I4qDKVnRoUFGb53Uhcgh8nCDGB5HSTIT4--
