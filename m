Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaAaMee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:34:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaAaMec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:34:32 -0500
Message-ID: <52EB9855.2010304@pengutronix.de>
Date: Fri, 31 Jan 2014 13:34:29 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] can: sja1000: convert printk to use netdev API
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <1391164513-11529-3-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1391164513-11529-3-git-send-email-florian.vaussard@epfl.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ONrOcXt6LKt0NDbHMTeKeEfQqEJLg4kwT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ONrOcXt6LKt0NDbHMTeKeEfQqEJLg4kwT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 11:35 AM, Florian Vaussard wrote:
> Use netdev_* where applicable.
>=20
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

Loks good.

Tnx,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--ONrOcXt6LKt0NDbHMTeKeEfQqEJLg4kwT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLrmFYACgkQjTAFq1RaXHN6bQCfYkXgwktoQz/ddv5HCTBAdrWw
dhUAn0Nub7lN4aG8rl+pYh9NzEKAsmPZ
=6PUa
-----END PGP SIGNATURE-----

--ONrOcXt6LKt0NDbHMTeKeEfQqEJLg4kwT--
