Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3JWPE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:04:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37642 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3JWPE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:04:26 -0400
Message-ID: <5267E56F.7030909@pengutronix.de>
Date: Wed, 23 Oct 2013 17:04:15 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 3.2 094/149] can: flexcan: fix flexcan_chip_start() on
 imx6
References: <lsq.1382345188.205668698@decadent.org.uk> <5265037D.2080908@pengutronix.de>
In-Reply-To: <5265037D.2080908@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MJfqCEx4O3daWDpGX3N9an0VGv2Fe7HPo"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MJfqCEx4O3daWDpGX3N9an0VGv2Fe7HPo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/21/2013 12:35 PM, Marc Kleine-Budde wrote:
> On 10/21/2013 10:46 AM, Ben Hutchings wrote:
>> 3.2.52-rc1 review patch.  If anyone has any objections, please let me =
know.
>=20
> Please postpone until:
>=20
> d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB
>         for TX and abort pending TX
>=20
> hits mainline as this patch (fix flexcan_chip_start() on imx6) causes
> another problem.
>=20
> As soon as both are mainline, please apply them:
>=20
> d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB
>         for TX and abort pending TX
> 0d1862e can: flexcan: fix flexcan_chip_start() on imx6

Damn, probably had too much jummy Scottish food :) The correct patches ar=
e of course:

d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB for=
 TX and abort pending TX
0d1862e can: flexcan: fix flexcan_chip_start() on imx6

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--MJfqCEx4O3daWDpGX3N9an0VGv2Fe7HPo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJn5W8ACgkQjTAFq1RaXHNpBACeLTKtobXOpSXlRUn2RXk0qVFL
YlkAniFmp2xwIfzDVgNQfSOnM06UDrvV
=uvFy
-----END PGP SIGNATURE-----

--MJfqCEx4O3daWDpGX3N9an0VGv2Fe7HPo--
