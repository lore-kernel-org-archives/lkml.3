Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbbAIRXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:23:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47299 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914AbbAIRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:23:01 -0500
Date: Fri, 9 Jan 2015 17:22:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        stable@vger.kernel.org
Message-ID: <20150109172241.GM2634@sirena.org.uk>
References: <1420754190-6309-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LEhai0xmYcLK0HEx"
Content-Disposition: inline
In-Reply-To: <1420754190-6309-1-git-send-email-peda@lysator.liu.se>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: pcm512x: Fix DSP program selection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LEhai0xmYcLK0HEx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 10:56:30PM +0100, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>=20
> The DSP programs are listed out of order.

Applied, thanks.

--LEhai0xmYcLK0HEx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUsA5gAAoJECTWi3JdVIfQin4H/3nFDYiHBbkQFmkVFt8Kf7S1
Sp2fqd9nNFQUBkoF47kAzj8J+H7Ra+64jQYL4W5Uupxjrx2pHnVS7RRa0yC1c2xn
Dea3SlafPWTg2NtEYRWtdpaGkCma1WFGJYNqHTN9l/+xkMGOFwG8JLEZPc1xP5x+
xCfCZSzUGPWs8c6369FzSvxsExXbJR1q2dZEv+b5bk6ZbuzpCrbeHN+BZRpvY6y8
oP7IWVRZ+6mmmdxP7YFPcui6/aepiSHa25EnlkN+s/vfHT4C/Q3GOSBHicuEceZp
yj0U13yxMrm3mYWwQP+vI4aWwvQ+9dlqoR66+G3QOc7UIZ/PQF/jNKzSAYERcbE=
=NYwO
-----END PGP SIGNATURE-----

--LEhai0xmYcLK0HEx--
