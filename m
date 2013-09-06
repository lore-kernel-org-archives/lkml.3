Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab3IFG4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:56:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51302 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3IFG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:56:24 -0400
Message-ID: <52297C8E.70101@pengutronix.de>
Date: Fri, 06 Sep 2013 08:56:14 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Stephane Grosjean <s.grosjean@peak-system.com>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: pcan_usb_core: fix memory leak on failure paths
 in peak_usb_start()
References: <1378450379823688500@peak-system.com>
In-Reply-To: <1378450379823688500@peak-system.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="L0Px724EDhVNthCLhfSF3CkAX8IXQTM73"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L0Px724EDhVNthCLhfSF3CkAX8IXQTM73
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/06/2013 08:52 AM, Stephane Grosjean wrote:
> Tx and rx urbs are not deallocated if something goes wrong in peak_usb_=
start().
> The patch fixes error handling to deallocate all the resources.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>

Tnx,
Marc

BTW: A simply reply to the original patch with your Acked-by is sufficien=
t.

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--L0Px724EDhVNthCLhfSF3CkAX8IXQTM73
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlIpfI4ACgkQjTAFq1RaXHN/FwCgjFYA+SZ2ODnXjZG3GA+48XOu
ktMAnRrV1hVQMrK4iAIkmXT4rbluRI4m
=ujBN
-----END PGP SIGNATURE-----

--L0Px724EDhVNthCLhfSF3CkAX8IXQTM73--
