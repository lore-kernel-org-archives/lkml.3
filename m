Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaAaMeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:34:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39732 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaAaMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:34:05 -0500
Message-ID: <52EB983B.70602@pengutronix.de>
Date: Fri, 31 Jan 2014 13:34:03 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] can: sja1000: platform: use devm_* APIs
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <1391164513-11529-4-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1391164513-11529-4-git-send-email-florian.vaussard@epfl.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fvPK7h6N2bVOfijUMCoGIjjFrwopFiNn5"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fvPK7h6N2bVOfijUMCoGIjjFrwopFiNn5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 11:35 AM, Florian Vaussard wrote:
> Simplify probe and remove functions by converting most of the resources=

> to use devm_* APIs.
>=20
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

Looks good.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--fvPK7h6N2bVOfijUMCoGIjjFrwopFiNn5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLrmDsACgkQjTAFq1RaXHMa6wCePt5blOzuVcw5bWtzbkSr+y8R
z2AAn1vog0KlU0ntSRZFc0TjdHlNN5JZ
=FHOG
-----END PGP SIGNATURE-----

--fvPK7h6N2bVOfijUMCoGIjjFrwopFiNn5--
