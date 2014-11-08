Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaKHJ2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:28:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51343 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaKHJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:28:45 -0500
Date: Sat, 8 Nov 2014 09:13:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Torsten Fleischer <torfl6749@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141108091306.GA2722@sirena.org.uk>
References: <1415380318-2065-1-git-send-email-torfl6749@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1415380318-2065-1-git-send-email-torfl6749@gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] spi: spi-gpio: Fix compiler warning when building
 for 64 bit systems
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 06:11:58PM +0100, Torsten Fleischer wrote:
> From: Torsten Fleischer <torfl6749@gmail.com>
>=20
> The assignment of SPI_GPIO_NO_CHIPSELECT to cs_gpios[0] causes the follow=
ing
> compiler warning, when building for 64 bit systems:
> "warning: overflow in implicit constant conversion [-Woverflow]".

Applied, thanks.

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXd6hAAoJECTWi3JdVIfQQsUH/0m/2WUprZGi84dUf3wvAcve
DCmv+/TVuZJaSP1bEV9Hg5URga+mf0HxLIHG3aeqV98aAqfsNk8U1mi0d30KIGsx
3FvIMQmgrb21qPqfF+PFHK/K0NJuw34UoB1pXD1u0zPY6oAw8EbZjHPWeSgfaSDN
m+nnFKblD5dvZx2TG60DrX2mMofcX6QQHCDvmQUyvApoLQmxBvc43BgSCQ2Md4+/
Owqk3sPTQ14dzmXNhJt7Ou0fiBPtxeSL1L/SFkVdYVo+U2qpalFpCWO3AKqVBq2B
jcULR3IIhdwqrHKX31htU/b8WxhPSKMcfeQlMBYKMPVnOeNu8iQOitum54eEiWE=
=9s+C
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
