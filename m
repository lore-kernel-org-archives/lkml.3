Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaAaMfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:35:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39765 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbaAaMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:35:36 -0500
Message-ID: <52EB9896.1080409@pengutronix.de>
Date: Fri, 31 Jan 2014 13:35:34 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] can: sja1000: remove unused defines
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <1391164513-11529-2-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1391164513-11529-2-git-send-email-florian.vaussard@epfl.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xJS0IwHDtwVVCnbGCReK0en4R63GCukP6"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xJS0IwHDtwVVCnbGCReK0en4R63GCukP6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 11:35 AM, Florian Vaussard wrote:
> Remove unused defines for the OF platform.
>=20
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

I've overlooked in my first review that this patch is touching the
of_platform driver. Please remove the patch, as we want to remove the
driver sooner or later.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--xJS0IwHDtwVVCnbGCReK0en4R63GCukP6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLrmJYACgkQjTAFq1RaXHPfZwCeMHbfrpk/Pmvn3p9iSaB9Yo7Z
6D8AnixweAmBCz4Hvcm9SZ9Cl0/bJI8H
=y0K2
-----END PGP SIGNATURE-----

--xJS0IwHDtwVVCnbGCReK0en4R63GCukP6--
