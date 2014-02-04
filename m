Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaBDKzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:55:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48815 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaBDKzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:55:45 -0500
Message-ID: <52F0A4C9.9060306@pengutronix.de>
Date: Tue, 04 Feb 2014 09:28:57 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Andreas Larsson <andreas@gaisler.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] can: sja1000: cleanups and new OF property
References: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch> <52EBA7E2.6090007@pengutronix.de> <52EBAA28.1070307@gaisler.com> <52F0A29C.9000604@gaisler.com>
In-Reply-To: <52F0A29C.9000604@gaisler.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4fAHtNshMupKGqoWSBxT0DGbLa4Gxmit6"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4fAHtNshMupKGqoWSBxT0DGbLa4Gxmit6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/04/2014 09:19 AM, Andreas Larsson wrote:

> Works splendidly. You can add:
>=20
> Tested-by: Andreas Larsson <andreas@gaisler.com>

Thanks,

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--4fAHtNshMupKGqoWSBxT0DGbLa4Gxmit6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLwpMkACgkQjTAFq1RaXHOgSgCfQtKZ6mHOKcBNMNpHNvkmo/m1
Kx4An2FBWVgNhIsip+DW4t0DjU2ofNyt
=cNUl
-----END PGP SIGNATURE-----

--4fAHtNshMupKGqoWSBxT0DGbLa4Gxmit6--
