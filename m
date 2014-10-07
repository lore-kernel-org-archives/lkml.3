Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaJGNHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:07:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38061 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaJGNHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:07:41 -0400
Date: Tue, 7 Oct 2014 15:07:37 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 4/5] regulator: Use gpio_is_valid
Message-ID: <20141007130737.GH5042@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-5-git-send-email-mpa@pengutronix.de>
 <20141007120106.GY4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qoTlaiD+Y2fIM3Ll"
Content-Disposition: inline
In-Reply-To: <20141007120106.GY4609@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:05:41 up 27 days,  5:53, 82 users,  load average: 0.31, 0.12,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qoTlaiD+Y2fIM3Ll
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 01:01:06PM +0100, Mark Brown wrote:
> On Mon, Oct 06, 2014 at 10:17:14PM +0200, Markus Pargmann wrote:
> > Use gpio_is_valid instead of custom check.
>=20
> Patches per driver please, this isn't just a mechanical transformation.

Okay, but you mean just patches 4 and 5 and not patch 2 right?

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--qoTlaiD+Y2fIM3Ll
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUM+WYAAoJEEpcgKtcEGQQzxwQAITHY27s/PRNELtXyI3tAu9w
LZ+hfFdnuSvvJESziEYAiu4Rw1j36184MemxfxrfM8LOKoOyClKb6ZGvnIjbWjnf
hZ+ZWG3jXRfBeUPdv1XEuOstYr383v40KSlsXwfWc02/1Ezk2oLcD2sHYVIHrnfC
9ws5tImNgYa4HZLUe8BydPbPFaSDMX++mfrHxUJTv9+/mWXkzmJJeWbnjt9a7PEU
vnl9WUmNvzxtnBGklPo3oxHNv5npj4Aa4WQ/0pji9utICnUJuNI5hDuZL6ifFlEb
HGRPHAxKD5yiHtXfALCoTmhMNQpVMBs5jmeidFsyih16aDm1O6QzY5og+KmhX/VJ
xEt9475l0K+Yb/gyRWWwiqkOTv6Tb9FPsYmavjeiD/2cPiDtQpfOsxj9Ri6EDTZN
CME6j7piwAaCk+clvdwuCQGJ3H/+mxN0/nTgvI5GamI07zkHwzBGwZkNwyp56e3u
dpjYxV5cSaWNmj9wR60ZD3sXiAjQehiWETMD1/XVdsAd9R2GgIf5Rxnptqhjclhx
u2UqWg8jU1RKR7WbjSZ0nBPqXN7p/9AynY8FJj15KSdi2dKoP+Xctdw1OJa+N6Pv
ZxMLhFMfKbHWF4SataOrV/UIbmUeGE/itnwlWRicxKuULzveS9WY96Bz+J+6aJJ8
M3xG6ZVRdDbbaLp1TTZW
=Qiuq
-----END PGP SIGNATURE-----

--qoTlaiD+Y2fIM3Ll--
