Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3EIJ2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:28:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52441 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3EIJ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:28:32 -0400
Date: Thu, 9 May 2013 10:28:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130509092825.GX7478@sirena.org.uk>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
 <20130508110451.GC3459@gmail.com>
 <20130508113124.GH7478@sirena.org.uk>
 <20130508120326.GF3459@gmail.com>
 <20130508123902.GL7478@sirena.org.uk>
 <20130508130554.GG3459@gmail.com>
 <20130508134814.GQ7478@sirena.org.uk>
 <20130508140618.GI3459@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z1EIi0fvCUyWUKja"
Content-Disposition: inline
In-Reply-To: <20130508140618.GI3459@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z1EIi0fvCUyWUKja
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 03:06:18PM +0100, Lee Jones wrote:

> Bringing this back on subject, whilst trying not to drag this out for
> longer than we have to. I think replying to one's first patch with a
> subsequent version has its merits. And as long as the thread hasn't
> become too overgrown I see it as a useful tool to obtain an Ack or
> further comment easily and without churn overhead. This also aids in
> your quest to save maintainers from reviewing the same code
> repeatedly, as once the Ack is in place it's easy to see which patches
> are in need of further review and which ones can be skipped.

If you want to do that what often works better is to post an incremental
diff rather than the full patch to show exactly what's been done in the
fix.

--Z1EIi0fvCUyWUKja
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi2wwAAoJELSic+t+oim99moP/RGvAOrhh8aFxyKWikGkO+ua
vhKRaifTbOYa+C5ISE1pwwGYsIbJaT+bwksVA+MQOEyOy9oEb0+2eFioUif9VLGu
zzAuoLKrCCgF5uYhllsGLRAlvPzclcvk2OFmjfaN9y7QWCloX3aW8sUfaF3iHdMf
h/+ooFoR22+S/iShTV1GbHFmest5g9LjnQewawilq0mMLAaxCrg19E/fSi8FaGMR
a9/T1bDLiBwkD/VR9022O3bfr/w+xKTbXbgP/HvJPWe8ljcDdqTugnwsT1eSI59Q
/enq17PaXBmlJ3+tZOVTBmR2kvi4Z1Mj5F++TzSNuEbZKNG33gf7B2eeMUtJMn5N
ZrXqfkTHExdcJXcqZb/1KoOcsQK7chk0d8Vv/Pk0Eg9QolzWf27utrazxsOIiPw2
i3ieQZQt1g33DDLwhuuwbDXn/81uz/iH63XqaqcKvX4tMGw2hO8QgQk6vsmN2bEU
2t//hugBOhmhIezmZ3Zg37JIBDLc4JdXUlGdulbUEudkJXdk1kJH6Q4XNZ5p2Z1M
y/o0zccjiIHC0LtogEaitK9y+IYkQ58/3tK3zbbzKOkQUsfbvJGLEvMFZJ1y42qw
0gvYxxIfKvNd6RlVYmsPQ5qneRbKL1OfiZTAvCMFDRXYsVMNZ6b7g5qpZxIOF4cB
xxIAKTJAkGfYQ8RR6R0V
=Tbpu
-----END PGP SIGNATURE-----

--Z1EIi0fvCUyWUKja--
