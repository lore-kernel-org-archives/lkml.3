Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3E0MTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:19:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42902 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab3E0MTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:19:22 -0400
Date: Mon, 27 May 2013 08:18:51 -0400
From: Mark Brown <broonie@kernel.org>
To: Nikolay Balandin <n.a.balandin@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Message-ID: <20130527121851.GC3660@sirena.org.uk>
References: <1369518640-7480-1-git-send-email-n.a.balandin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <1369518640-7480-1-git-send-email-n.a.balandin@gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.140.42
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: lp397x: use devm_kzalloc() to make
 cleanup paths simpler
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 25, 2013 at 02:50:40PM -0700, Nikolay Balandin wrote:
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>=20
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Applied, thanks.

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRo08oAAoJELSic+t+oim9NF4P/j02DIBaaEnUOIE7Q/DRcui2
MJvSIxmCEPJlgoVRq/iJLCJkrak+HwvkXoMfCnKVxxd44sDoZRquYVBKPLqOzsEv
ddiwR0KQ76pPqMYtRETxGdP+LPhYvp1n0pZlI2OF5zzhu5kk6mHQpmCAu87VEWb6
vS7tjy0chRIYhPDMZWvmKdQg06EZVryXL8HpziPPZ3U5u8abZDWv3gw/i3LyrU4U
yIILlulSi+9GNarDgFVY2H9N3IxWGeU1hnl6UvADaYHCuHgNFc/hKThN/KLbVN6t
GgPFfAnuRq/PgHbPIouy7OueVIv1yKdO5a3SxopVOo6TEk+8aet/1/HSqDN27dAg
/2WhBVpDL+zF8k+SGpoB7pBQ9xFmWzvzQG7NcrcomEMJh1HvvY/fPmLmzj3oAiek
ffNL0wZy9naY8J2sR6nOyRQggjtgccGnIpTxnr0le5uK4DBJ8ANHddDiRDcmy0X3
1asq55c0+TpXcDhywmKN8jD8dYdw0s1GoNJXWIOAwkiSIAa8CKfa1a4OO3cYGZmN
gNflUj5wAqj/j8y/96Qaz2yEctPmS8/htG0J1+aNqVqx1qtanLEXJIjnaCeyERK9
QOJO3F+fSjekx3utGb1K4xaQ6pKZSQKquSMm7jLWiXRLATGUTC7Q+E+TWSMxJfgE
O19RhdBjCnDsFkrN1la2
=zuM+
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
