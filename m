Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3H2Sje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:39:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57901 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3H2Sjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:39:32 -0400
Date: Thu, 29 Aug 2013 19:39:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130829183913.GS10783@sirena.org.uk>
References: <20130825155413.GA21566@raspi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W8kijDWvHeraQFS8"
Content-Disposition: inline
In-Reply-To: <20130825155413.GA21566@raspi>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Add devm_regulator_get_exclusive()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W8kijDWvHeraQFS8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 25, 2013 at 05:54:13PM +0200, Matthias Kaehlcke wrote:
> Add a resource managed regulator_get_exclusive()
>=20
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Applied, thanks.  Though I'm a bit suspicous of exclusive() usage...

--W8kijDWvHeraQFS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH5VOAAoJELSic+t+oim9n34P/RwVogrTyBJPuPtREhOc19DB
3A27dwyGgY77D4hPFGUvNpSnfd4sGbUjy/mEzjNBl5RQoo8w7vR1Q03pgwmHNokN
c40HcF8R5pjmqbTNeJzXyscgszDxw9IYeyAB30Y5U23dlttyy+MV8O7YtDp6cMgL
Yx8ZDhmKps4Lhy2ncFEgJhvQuZRs0GyJYdrstGjRcpI1H0z5sOuBVJ7sFPk1vozP
RCG85cXJK1IIl2lP2G1wFOoqfkJrjYv/L/YDv96NpnY9vSKNTV9OXoFx9qOcmkcs
rvUUr8CjHr71Kay2LaFlSoHkgzvDr3Yg+OnFgcOJ8H3A0i4BS5abwknBmrDC//M6
xkdv4KRw463u1Nn+IaIKLwIgJZYcyNq41AdIx+M9qD/LlnnVNPpYFqyfluZ5k+YN
Tej+OiAufPqFQzP4p48tZzjjNtMUszGhx5czkfNIwcfldgICzlfrcsUSuoX8czHr
2NQCdkizdIxY8JgWjifyP8e6ENnbZ/sfNHzVKzL67vlfcCEpgzoIeFCughib4UX6
/rMOVHmie5f7YpP76P2zMAUiWl/TGCJRwJytp1HvQUIJczpp/MDWyOVlBRmaQUB3
n7ttIbI4ViTNm3KqSsqA1Xa+WNAlZYJlyLH38SMs2FcpYrPw8R1J9+9n54Na2+99
aM9X9VuVdX3QInfOQpWy
=ONhm
-----END PGP SIGNATURE-----

--W8kijDWvHeraQFS8--
