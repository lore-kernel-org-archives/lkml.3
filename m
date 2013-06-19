Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884Ab3FSP06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:26:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42181 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934794Ab3FSP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:26:56 -0400
Date: Wed, 19 Jun 2013 16:26:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Oskar Schirmer <oskar@scara.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <zengzm.kernel@gmail.com>,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Wolfram Sang <w.sang@pengutronix.de>
Message-ID: <20130619152648.GW1403@sirena.org.uk>
References: <51B749F5.3010907@freescale.com>
 <1371647766-4900-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8JMtXNYTIIy8Rvxv"
Content-Disposition: inline
In-Reply-To: <1371647766-4900-1-git-send-email-oskar@scara.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] sound/sgtl5000: fix codec register initial values and
 handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8JMtXNYTIIy8Rvxv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 01:16:06PM +0000, Oskar Schirmer wrote:

This is a set of three unrelated changes, they should be sent as three
separate patches.

> Further, mask computation in declarative part is obviously wrong:
> Fix FRAC DIVISOR to provide an 11 bit mask correctly.

What makes you say that this is obviously wrong?  It's not entirely
clear.

> -#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
> +#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff

Based on your changelog I was expecting a mask with only two bits set
here?

--8JMtXNYTIIy8Rvxv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwc21AAoJELSic+t+oim9WvMP/ijace/A0w4dhmAuFiLXvObG
73OtHF13uQG/4jrJTcmYe/3C8MuYcgcSLmHHe91+z05zXbgr7JUP7QEGqccfjwkO
YaMx9RBuh+UsG0gfOnjCcPJ2SO1vf1tk8LrExMfqipwLxF+C0yPEI+2uqlqLRkkG
GQwyY3+YOXFsYYdGTOUwHAvgLzGUEq208Y7Ajlbc6NZdCebIY825Njr0IlAQ6wT3
PkYF2LZNiPPF4uc+UaqH5JCHY69LlXFLlDwPhq9Uqtj3jPYtLyeDYJ6l+eOIHjXR
yk3yQE0lW87AH7Q2T8MF+76Io0X6oQPRVouvDYHtE8znnx1fyK9gl6g6taz4FMF1
DYSGMlNlCIG7NzbYtoarPKyuavaKIKdjtUrqvsA2isvJmAqzbpT/WyE2i2TUPhPi
c1ITtKdGI2qfb3Fuz2CnC/MKhn3YcFRikgN9J0tEjBGFsnhmexbccPYo8AArkqsa
rLHBm4x0oEm1TuIu1gRhQ3mRLGF2XgonV4K7yt0q0OLgi3CDqX9oQh4iUKIuiMXN
KmpPOjY2kyrNsm9fHedMmK9LktUfHvtTbyPzZF/SkMFr06Xlc6XNZgkEwL5oKL0e
HTiaCo/u7fqjBFGchPAZPI6ADSRbKhim3AWkJbbmSErknKu1NccjJ2cy2KEm4AvA
JrVnr4HqBCNAxP8OYEap
=L+gf
-----END PGP SIGNATURE-----

--8JMtXNYTIIy8Rvxv--
