Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaBWHLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 02:11:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49978 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBWHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 02:11:51 -0500
Date: Sun, 23 Feb 2014 14:12:09 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Message-ID: <20140223051209.GK25940@sirena.org.uk>
References: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QcUX/sQL9X4plCuL"
Content-Disposition: inline
In-Reply-To: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.159.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/2] regulator: core: Fix ops->enable/disable usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QcUX/sQL9X4plCuL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 05:36:02PM +0100, Markus Pargmann wrote:
> Hi,
>=20
> These two patches replace all ops->enable/disable by
> _regulator_do_disable/enable function calls. These wrappers also handle g=
pio
> regulators.

Applied both, thanks.

--QcUX/sQL9X4plCuL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCYMgAAoJELSic+t+oim93VwP/0X2IBClcRO47LVL4gvnOoLy
XXb0LPvXkOcRBSI4VHZKTMAhQY6/5n1HGzrGVXDP11KilZE74gt1X0sBHFz+Fzqt
fwZ6Hay4WrFRfWjiNb9bM98Bg/I1hL87sJbfbyCr3riVhqTZDulrZLl+LIrvFFJx
BSkKZiT+9+5QtyuX9du6lzoU/LalqZBFsXeA0DlCwzC2KwY4+qN+YJjrQo9HmW5I
XCOQSXRBC8MRNXbwd9dGAc4JvA2w5HX3NlcgtLwTFBCSWUvix1dMZAWPApNmNcJn
px8/Uo/K9FTreWQL9ngD+143vcL9EogYrLCRJTO/9kt5FAas2oALGiAh9L90kzf6
015Zd5GZ2nr/fDE4+1mAI7yaRQcC2BQVjqRl1xYDez/XPLET0l5cmdKY4+1OyBBM
ReGRQbPBqODiirVm7Xxbb83FLINlGf1gAlcBwbAfulabd/5qzOnwW9qFqGnjvYlK
81YLB4utBbe0aSyplvMd4tZDvHAmMPY6v8ppgbhfK3+Ro0N6gfOm62R3OxNV8eaK
USb4UftszwmiBYVp0EgR78eRNEPcncy3jagLe6vKV/szqbywPPMjAyXCTwlHz0E2
eXPUyYUo+5XKZdn7uy2qEaRbaO8qmzbR74kMVAxE6YS84Sh0zfkSJ+udDu6CwdMD
BtZXzMIlchBlrpWzpOtQ
=lmx/
-----END PGP SIGNATURE-----

--QcUX/sQL9X4plCuL--
