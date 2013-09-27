Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3I0OCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:02:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43935 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3I0OCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:02:47 -0400
Date: Fri, 27 Sep 2013 15:02:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130927140243.GI19304@sirena.org.uk>
References: <1380288314-24064-1-git-send-email-nm@ti.com>
 <1380288314-24064-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+WCZLadiceW8Bs8"
Content-Disposition: inline
In-Reply-To: <1380288314-24064-2-git-send-email-nm@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: ti-abb: skip optional parameter for
 ldo-address
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D+WCZLadiceW8Bs8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 08:25:13AM -0500, Nishanth Menon wrote:
> On platforms like OMAP4460, LDO override is never used. Even though
> efuse determines the ABB bias mode to operate at, ABB voltage is
> preconfigured in internal efuse registers without the need for
> LDO override for bias voltage. So skip optional parameter if
> property is not present.

Applied, thanks.

--D+WCZLadiceW8Bs8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRZAAAAoJELSic+t+oim9CCMP/R33Bu/8M4/PdqFKbjaXunzv
e41YWGGNb2OpsKQZTjj3nPFrrD+VL/50qNb4AWfEfuoAsDm3cG1VU77GdQl5M/sb
ck/f1ZHD6u88y4lvwkmpN9dCcJL+5314OINp+mloiFc1UCruDBinCGXvejLxy25+
jhK+PU7QYtrz/ks5C6oh8jV5z3FXxxunOimB9cEii4LslEIV+iTemiDTxZQkunZk
JZorb5ceZl7aV7mfuTU1yWau5PzdxvZYiDwCQonJozLP0OMNKknMUna4uq1cnwOd
JccE1rzmmtDetO1/9Y2t1Rmx6AB9K0HyRZqoDB7M5QjdhPP7pin7b+oirMNO1qQB
Sx38QEklz9mZiTXOlgqGA/QT2eKl0pXPW33h96sw/xDHK74rslq/yuJJNH4bKlGs
mF9HnVxzfflTfm7iTO1MaUlGfMLv8XvGNsUFX577ebMbCbIOZag3y2+Vi4Iwfzdr
8yG8mhEE0FrNLwEf2K/MO9hi5edB0UPilu7fdshJETcpJUoT9elENC5gsAJqKaZb
cfIWf6FQ9aXUfGqAlKG/iLwhqbyPIaeiA8k7ERCFmf4ROU0cwyMXqVzLXcXMgNRw
Ds1Ls4e6DVYd4vuKPC69qiYFaYatDGZ9CQ+p7Fj8NfZG7FK3Wi2VZawrgR9bBEJA
dp33NVKfn3g3s7SANHXP
=ElnO
-----END PGP SIGNATURE-----

--D+WCZLadiceW8Bs8--
