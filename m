Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaDNTlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:41:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32856 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaDNTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:41:39 -0400
Date: Mon, 14 Apr 2014 20:41:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140414194111.GN25182@sirena.org.uk>
References: <cb4eece4e6fadca4627a869bfe6efb3d41c66700.1397468934.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v541l457l4DThMFo"
Content-Disposition: inline
In-Reply-To: <cb4eece4e6fadca4627a869bfe6efb3d41c66700.1397468934.git.nicolas.ferre@atmel.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/2] ASoC: sam9g20_wm8731: remove useless mach/gpio.h
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v541l457l4DThMFo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2014 at 11:54:38AM +0200, Nicolas Ferre wrote:
> This include file is about to disapear. In addition it is
> useless for this code. So it is time to remove it.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Mark Brown <broonie@linaro.org>

--v541l457l4DThMFo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTDnTAAoJELSic+t+oim9aU8P/29u0JeTTHZiNzf8oT0hD/N5
OjZAP9R23EEgWsoox5ftkpeLpTjIlyuph97jQUqZX3EWJtcQEFcyoglR8GEmYX8b
bXj52N1QBwP9QYcxqmYv5ZGmX1r43S3O063Lme+CxsxX0NnrMSFi5YqKGog+2+si
r4969SFNKynNsxMSblgvIsapohWbSU1FKpklJNlMuABLDfZLOQkqS16nrVTWlAsB
JR6/7h66IbhyFDj/YnghueoQIiRAqttlnYZqr3QOMqwCNLCPeE8ehnLK9JAA6jzH
mM43keljoPRt4ve7W6GZDidR4uYOC2VfTEUNcl7qKosijtyL1XpER/H6HyUZ87VI
KV1I5lugIO/pZwxsnjzLfKRSo3mLXDMfjbmeF6GaRx2yOzBt3GLexyQgjYqKCWAI
jYf02IKACYdJG4S+BzBJVfAJYsWCk4rvYcm/SuqwG36A42KJputZGFa++/CfXFPh
NJb5bzDiv4LsmhE3T8ZSW1jMl5yDL0s8pi454R8aZCzSpzNl9gZCgtwiYMw2D3pz
fmrAPYn01mo149M09IUxFs3/5WNGjs5ai9SGuItOYZqCo6y27naeZSWp61xSiIcq
HqywMBdztcf/g8cC0gFwYKVlH8fqveKtCIDxVGwtrYt8PgLrW6xT8+oH6/I72+Lq
gGKlcEYl4MiG3pVQo8JG
=HIGG
-----END PGP SIGNATURE-----

--v541l457l4DThMFo--
