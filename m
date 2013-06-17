Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3FQKgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:36:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33214 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3FQKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:36:22 -0400
Date: Mon, 17 Jun 2013 11:35:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130617103557.GC1403@sirena.org.uk>
References: <1371463695-21252-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="otRuG/a1bzWynmKC"
Content-Disposition: inline
In-Reply-To: <1371463695-21252-1-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: pl022: remove unused ret and pins_state variables
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--otRuG/a1bzWynmKC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2013 at 12:08:15PM +0200, Fabio Baltieri wrote:
> Removes the warnings:
>=20
> drivers/spi/spi-pl022.c: In function 'pl022_suspend_resources':
> drivers/spi/spi-pl022.c:2322:24: warning: unused variable 'pins_state' [-=
Wunused-variable]
> drivers/spi/spi-pl022.c:2321:6: warning: unused variable 'ret' [-Wunused-=
variable]
> drivers/spi/spi-pl022.c: In function 'pl022_resume_resources':
> drivers/spi/spi-pl022.c:2334:6: warning: unused variable 'ret' [-Wunused-=
variable]
>=20
> introduced in:
>=20
> f1c9cf0 spi: pl022: use pinctrl PM helpers

Acked-by: Mark Brown <broonie@linaro.org>

--otRuG/a1bzWynmKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvuaKAAoJELSic+t+oim9AsUP/2PqPzsj8t+s0KOTeuMUAM0P
A68aENNPaWy/5Mt1UQKwcvffJ4gCyLCcYqIAlSRDF+U2ZtgOWIJXirKCmhOmEaGz
mHuVlHusVcyuAJ8s5nnXOg2KRlYpwmHKUmfkSjUpBUZS1+sDqRh1azH9Mvm7D9+s
H9hks4/k9ThTn2KHSchl1nipDb4bFFH5MeWE9SIHb6+SBWeX3wQpQCDNxBsXZjlo
PA0DAqmYmFbh/P7eDWr3pDL+NSuZ4AvzYmz/XsokYqx2LMuYw2E33XIp/IWw7EAE
kdSo/hBQHAY5hYleDzF8WVoxjqRMW0H6T4AKHRbCldOor8siM+YqUKTELXc6Lsdh
CtAo7eJGBeCcovbLNMXLKAqLzHm8gpbVYdbtpIKnzTupl+eUX/ByToWorF0fw3UK
/gj/m76zhWHVTTnS/90qDDtEMcoGq702QHTEprR+LFVtLAo6z5jyiFlEtB8Vxkdh
fxXNB+er58+Ait5wMFBI9HyvmgKDTmhh/x9ZSY1GfVfOJriw9YmPDs/vhdBAhcXp
ySM4JxxTKXQrNBrKe4Q4XShKswF4dQQavg7cNm7yGGIM7z10GaKpSS34aK2UX78i
OszobP0EMl+GShEdFL6vLZ0JG3yEYmYHzE4bU9lPlUNb6NXOAFb9FzfxTlR0lRW5
XBUQY2foi6EKusao5FUo
=Pf3x
-----END PGP SIGNATURE-----

--otRuG/a1bzWynmKC--
