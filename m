Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3AVWad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:30:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3AVWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:30:30 -0500
Date: Tue, 22 Jan 2013 23:30:26 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 10/33] i2c: Convert to devm_ioremap_resource()
Message-ID: <20130122223026.GA956@pengutronix.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-11-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1358762966-20791-11-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 11:09:03AM +0100, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
>=20
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: linux-i2c@vger.kernel.org

I still have the concerns I mentioned in the previous discussion but the
series seems to have enough momentum that we could also just try it.

So, for I2C:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlD/EwIACgkQD27XaX1/VRsYDQCeLQxcrfIPVKYe5Wu5vA4OfFtX
jqEAnjBBmERGCFxh4rbz8MuaVo20COoi
=5MT+
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
