Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3EHNs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:48:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53225 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3EHNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:48:54 -0400
Date: Wed, 8 May 2013 14:48:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508134814.GQ7478@sirena.org.uk>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
 <20130508110451.GC3459@gmail.com>
 <20130508113124.GH7478@sirena.org.uk>
 <20130508120326.GF3459@gmail.com>
 <20130508123902.GL7478@sirena.org.uk>
 <20130508130554.GG3459@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d5xRKMqY7hkGAt+u"
Content-Disposition: inline
In-Reply-To: <20130508130554.GG3459@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d5xRKMqY7hkGAt+u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 02:05:54PM +0100, Lee Jones wrote:

> I'm saying, from experience, from the developer side, that if a
> reviewer goes though a patch-set taking the ones s/he likes leaving
> the rest behind, there are bound to be merge conflicts and semantic
> issues which the developer will then have to resolve. Stuff that I
> believe is added, unnecessary burden which would be easily avoided if
> the set is firstly reviewed and _then_ applied after the Acks have
> been awarded.

So, you have to assume a bit of taste on the part of the people applying
the patches here.  If you're seeing merge conflicts that's probably an
issue, but then it's very surprising that the patches would apply
successfully in the first place since the conflicts generally come up
when the patches are applied too.

The other thing to bear in mind here is that a patch series which is
"here's a bunch of random changes to this driver" isn't the same as a
patch series which builds something up through a series of changes.
This series is a good example of the former - there's a few related
things but really there's no visible relationship between most of the
changes except that they happen to be for the same driver and sent at
the same time.

The big downsides of not applying patches are that it takes longer to
get the benefit of the bits that are good out to people and the big
increase in reviewer fatigue from having to re-read the same patches
over and over again.  This is one of the major ways problematic code
gets in, reviewers eyes glaze over and they just start missing things.
There's also the fact that serieses often end up having separate bugfix
and development components which need to be routed differently anyway.

--d5xRKMqY7hkGAt+u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRilebAAoJELSic+t+oim9yoAP/2eAsPKTIFw2nFGkn6BG6Q/K
/deS/CTUOkLn5inLi+5YKPaA3jlNhKQxfbxsYl90aN1YS4Zw7KxtzknarEyNPz11
PXGVfrZe0WStlOeZsFH5gokfppXlLxZbYXT4M0KN/4JUnQQiXFRr9jQC5z8W9zyI
KlckvbzMP5UnC2FQEWaPZU71sAvPmH70SmdA9lXWRKKgUsqWVqk/eRUIgT+w0NVT
9U5cId+A94AklJqjEZlntryF0rVb/IkX2ez9vJkVuWOW+v0GbWGFLtG4jkbXSsb8
PxiKLEMxV9AfNMPb14HJAn2q67q1FSL4AZaBdkb1R9cDDZjFTKZPwdYZ7hPzJS5r
tA61RHPWjw40wafGv4wSTeUbfLh2z2JzjNmvE5ZX7g07HCxSnHHADen+ZbykTr79
39nY1B7GV2VAs1vEP9tb3Plenmjf24QLX0+xPIjs/UDb6IUhkEH90TAVlFs8sjSg
eoa9cN8wVhtz3lDsn4dXwhRPuP0e4tXvWxwRBtAf5JiIvdJWNjjkKNW3RU/sHpZZ
8+E8KKH+n6qHbn/qpAA+1oDF15PzaWLabzGxQUkYq9KWcCHnZYrjwJ9j3/rXzZOx
c4F3NH2Bqn0Bl5WxlbDh7OGaT012kNcdFYX4ooxTZdW3II35fNRXBKNPuTXM7grU
whZ8bJLVZkc+hfXtpczG
=kwp7
-----END PGP SIGNATURE-----

--d5xRKMqY7hkGAt+u--
