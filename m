Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaKSKuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:50:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52941 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaKSKuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:50:10 -0500
Date: Wed, 19 Nov 2014 10:49:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141119104956.GC22111@sirena.org.uk>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
 <1416336354-32148-5-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aHyShe78FfJzbeER"
Content-Disposition: inline
In-Reply-To: <1416336354-32148-5-git-send-email-lars@metafoo.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoC: ad1980: Remove ac97_read/ac97_write wrappers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aHyShe78FfJzbeER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 07:45:54PM +0100, Lars-Peter Clausen wrote:
> Since the regmap conversion ac97_read/ac97_write are just simple wrappers
> around snd_soc_read/snd_soc_write. Use those instead directly and remove the
> wrappers.

Applied, thanks.

--aHyShe78FfJzbeER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbHXUAAoJECTWi3JdVIfQH78H+wW+1N1PLGwgco3ZAv7EWEKO
lAGvY+MJTE0mkHkf8gYCbAuHAgXl+RgUQWOwwh4JCZNLqN8c10DISYZz2la4hnTR
Gavww37mDXFv5wV3rE8xZPyoj7sK+3FKzrFzuwc2QoNBXsqIeWyaP2FqygoLBahH
GpmRQ5/ku+8xgibWpuLECUm5V52iwk32ILVvy+hBQfR8SEXzypQWQAqmkgfgv+Xd
nB8DjGogNEz5RyZR78iYUPFCUPNGDwtzkgZkQvLrXaHbSfCUOumTFgBlyEH8UmWC
Uv95JgRrAkc5v/MAF9/o82xxsjVShTmw6vvyPBPcbHO5Ie+dfwVxAtmBBvzelRg=
=/YfP
-----END PGP SIGNATURE-----

--aHyShe78FfJzbeER--
