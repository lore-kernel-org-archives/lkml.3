Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaCDEAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:00:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55052 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbaCDEAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:00:52 -0500
Date: Tue, 4 Mar 2014 12:00:47 +0800
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140304040047.GB2411@sirena.org.uk>
References: <1393844903-1295-1-git-send-email-nhcao@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I7xMaAXwyt9AGI17"
Content-Disposition: inline
In-Reply-To: <1393844903-1295-1-git-send-email-nhcao@marvell.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] asoc: soc-core: fix coccinelle warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I7xMaAXwyt9AGI17
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 07:08:23PM +0800, Nenghua Cao wrote:
> From: Nenghua Cao <nhcao@marvell.com>
>=20
> sound/soc/soc-core.c:2708:6-13: WARNING: Assignment of
> bool to 0/1
> sound/soc/soc-core.c:2726:3-10: WARNING: Assignment of
> bool to 0/1

Applied, thanks.  Please use subject lines consistnt with the style for
the subsystem, CC the mailing list for the subsystem and send the patch
to the maintainers in MAINTAINERS (you've used Liam's work address but
he lists his kernel.org address for upstream).

--I7xMaAXwyt9AGI17
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFU/sAAoJELSic+t+oim9vBAQAIlIprT+7ZGJaE2vEIFGAnMM
0YNFlqlHFYNHB3ht9V4j2kqhtXup5QRE94STozVxtzCrI7GFvxtWU2O5RYP985Qk
lc8pD4fYO4AV3WR9zYegBnUOwZmcHOOkZXYGhoUHB8KUI74POlmWk93ObkIOQfhx
7xVXD3AGX5M5EVuDp52pqoMdFgMnjQFkppyWg1q/qWsWo+8oqT1RYPBZSkIwffLa
qNFuZ4pydJdhF8a4xmNtNqzDe0RZ/H0Hmdz2GouaniHU2dQ3Tt31tFpsliV+hWb4
i5zcjiXAP+s6oqFN12UU79/x4vDFdLVeYevJiH4tTe6IhQJfpfRVtjAYB9ZV4aFm
YKjfEH2x9nf8aErT/6c6cfLg8fEgCeY8fJcCzGg8S89XFWROFZSXkF/GmjXtfKpv
j21QQEh2fpyEMn/cCkxi8q1zbN6SzrvMJg5i08IYJBBGplds35FEPqOMJKTyP5K4
h1MRdSmDe7XrC/vrCMOXFgjtdfBR417Mk7snqU2vsC8bZE2hQ6ZxxYlHs1wmpEiK
ujl6BFeEmNKRLQ1lw8iaoIrFUpCOn+NVXxyrxfTkXaEsSJJeVM6D1vF0HRkUmDkY
t/FtBP2YZAUrlQ1TBzuFHUz89aeZi0xip9sRRQCtTLKNj1HaC5Dv18HoL4duILOE
tuQMc1IQFefx6ksr08bL
=OvW6
-----END PGP SIGNATURE-----

--I7xMaAXwyt9AGI17--
