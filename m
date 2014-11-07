Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKGLbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:31:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48420 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaKGLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:31:06 -0500
Date: Fri, 7 Nov 2014 11:30:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20141107113038.GL8509@sirena.org.uk>
References: <1415038327-32616-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6ToqNHb1ZAhG2TTx"
Content-Disposition: inline
In-Reply-To: <1415038327-32616-1-git-send-email-mpa@pengutronix.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/4] regulator: Fix core behaviour for gpio 0,
 remaining patches
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6ToqNHb1ZAhG2TTx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 07:12:03PM +0100, Markus Pargmann wrote:
> Hi,
>=20
> here are the remaining patches of the series. Version 3 contains some fix=
es for
> the first three patches. I added another patch which fixes a problem I no=
ticed
> in the tps65090 driver.

Applied all, thanks.

--6ToqNHb1ZAhG2TTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXK1eAAoJECTWi3JdVIfQfc0H/3BPpCIXDgSv9yA+yr1uMBw4
FX4hrXodYh1ifenEzbraEdK9SLNz50KhwFPDAk/zKyE5CIPKzDY7yWb3/KLBemcq
DzBaWMOBCYlGrYpfni3Qzsw0MKCNYN12wg12GofE9qS5ZCygvyunDqRTE/DEFl9r
bmoO/Zh7Ea5Kohkce6TwtxwUVF2X0AhsfF8X3OCL+qi4EdySipXTROJ/H0FEMwB0
7nn0WRoJkU8SnOMwRtsk2iSBvhpUA+Dkw9uFBoT57zuOjIJJVFbEpW58Fomc5e+g
R5v671bSv8qkVF9aZK4bwsi1/0apEqksMu8uquwkNX6R1nsiHjW83oWxJiRRMwI=
=5vNn
-----END PGP SIGNATURE-----

--6ToqNHb1ZAhG2TTx--
