Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3HNQt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:49:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51976 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121Ab3HNQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:49:27 -0400
Date: Wed, 14 Aug 2013 17:49:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130814164908.GA2401@sirena.org.uk>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376471493-22215-6-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <1376471493-22215-6-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/29] spi/spi-{bcm63xx.c,bfin-v3.c}: simplify use of
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 11:11:09AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.

Applied, thanks.

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC7T9AAoJELSic+t+oim9RUgP/iGWJ9ojjBPTSuLz9V0StxOK
ARqaFHRNJgYvs6Nkor8p2IAvmOYqwBKInyUjgb1G2M92qxVs6C1Z9TR1WZchaLzk
Pas9h5EAaRmIsuD2+IGUoXaKpEJ8NO4nvaydypjVaOhYdYOKszXTzLAd2jkW3fYe
K7sI55VSzW7zpkMt6NC9Nw6AkVJItACmESwS12zE1Hy9pVlgy1HBYRpH2p4EF2kA
uLyVoMkqtfviwKtnZs1UY7XXFcUCVvd//jpD9XJHSBltdufT3pzkdOfxzl81B6YI
XiWHNq0jiwQJuGk/ovYnV2K00Kw5itmUnMGesUtb1EQIDCgvdcj1mwHN4gWt9tY6
1tvYP0ZvqEiZ4fRra49piXbp2EzMQt77c8GP5jf6GerHWwWOSfOGo/OrXdNbTnmU
l0HTkbab3FDaggSrSjGbgInyZoTEcWQvBNPnyEZR6q42KxfRVlA6eJ4q0oawXbak
s0dcrhwwxIRPPAX2awzbN28goMjRZS3g3XlR2Z+yOlroBVDkPmEkncaxhV1R9IFM
ctNyctCcgSAT59MiOppXzIZAm++DT+W8waagOi6ZXslYqBuWo/NPYPI4mLAa4jEs
4uhsmnjIJrlfBqlS9oUwuJFY7vgdapYnWA96PZ9vnBU2BEnLU6vygHuH/iaE25ba
tFnmsXm+lwyewezfNGu0
=k3Jx
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
