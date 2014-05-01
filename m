Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaEABYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:24:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53393 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaEABYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:24:32 -0400
Date: Wed, 30 Apr 2014 18:23:59 -0700
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140501012359.GH3245@sirena.org.uk>
References: <4308079.So6q7GrfYB@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
Content-Disposition: inline
In-Reply-To: <4308079.So6q7GrfYB@wuerfel>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: cq93vc: fix cq93vc_get_regmap build error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 11:06:29AM +0200, Arnd Bergmann wrote:
> 49101a25acd69c "ASoC: cq93vc: Remove the set_cache_io() entirely from
> ASoC probe" introduced the cq93vc_get_regmap function that has an
> obvious build error referring to the 'codec' variable that is not
> declared anywhere"

Applied, thanks.

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYaIsAAoJELSic+t+oim91NsP/0GhNAr3UjBZ/tD/7hDg4dEO
g1gnqcd8IXBFstT5a9wWZ0ccLdyh854DUxyWJPtDewdlgez0N+FYOonGVxm41Ons
UogeKYVVPA/XGATJQvMri5steEoXKMrWGgTJJs8lCu1rB2PA3cfVqD46jqHETOOA
2xAgzkvn39bBqpZxle5zm+6W97aYX0nNf9ucTCYV/ZE5JbvXSHEBIezpF58E/J8i
RU62h8r5BiYkj5JlWbxPjHc1Tgc6W87D7590YZXz7EHQAEBOiVxkz0/tylAWF5Zt
o5MACL0vTtlapE5c8kN5qPOkOdaTJ1SUjRgXStTCey99jcc3Eq1dvR6Ug6R9FsZ7
+GSRvq7rOMrFCLLeRPcJdTnEbjMCp7u2fGnwUnzyXu3cHxLKjcH5x4drVZ8M7YdX
/rgohdAOxVk3WLrFiYiYjVVIosbLStPKvHLIwvxk2T/+XYeiPyoA+WAdoh4fp2dK
hMbWdMRZ8JSRdrYds/QCnfiJaL6rtUdijnt5YbPwtLZ0nOIdlFZZtGr9uz+l/BpY
Bpfe349cGPmc/j3ZcKBgU0Czb7j/P5rRpDtE50ZIe/2nhaEfJHAff8thnxnvqvJ/
1E6xe2XazCq/D2PAn82+gXakUHHMlfAhPyW3HWNjv3hAJnrhbaXYwKTLdNGMPDbj
6JyOOEX2N8NL7xgdoFbj
=/FhU
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
