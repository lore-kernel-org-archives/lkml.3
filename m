Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3KRLQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:16:05 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39185 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3KRLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:15:39 -0500
Date: Mon, 18 Nov 2013 11:15:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-networking@linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131118111522.GC10877@sirena.org.uk>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
 <1384560086-11994-17-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline
In-Reply-To: <1384560086-11994-17-git-send-email-taras.kondratiuk@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 178.107.40.197
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 16/23] ASoC: omap: mcbsp, mcpdm, dmic: raw read and write
 endian fix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2013 at 02:01:19AM +0200, Taras Kondratiuk wrote:
> From: Victor Kamensky <victor.kamensky@linaro.org>
>=20
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.

Applied, thanks.

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSifbHAAoJELSic+t+oim9bZwP/0VR95R4lczYwmThvtn5zfGF
21fJVSTfe2V4oxx/oNKkbx4S0Bk+vbTmHzYV9f5qD4FbV/x6Iud6G5GLXpX3Nw5F
lHalWJ+79JHOPoBGKL2YGORoNHMnYUVvAN42mA93h/Z7P0t2r8zE94UIW44za1r1
0r9lePznWK1XzHNFngHDuLdT1OHlvaWSYhxppWaoDdUhBOrtYbT6zWXrpEmqGLuB
HwZcqj7Ne8dBE9RpC5GL0MGA+4KPzO6/OG0rHIG5A7r7OyrlOt/Hwoyzu2uVEDsy
tapaznfpyOGa7fqbiNO6hRhvXwf/eJYoOc93qDEZGo7TgdrDF2GMwOKsFNbsUDfn
XDB/exDaJWub3TtY6bNB+GG9oZd7cwTqWs9L4vaYYFW6DwAGmFjt8pVoNTmVYbs1
r0qe9Ynxmhb4dESvBhRK6QvfsApgEmt+WeUbYH/gTsiuXU+tj96O1J6lyV3tSSz2
3KsLiPoDeGFTGzF1hprJ08a+ZhFjvZQz4O/zt+KyDZKL01142G1CDf8dJCJEabTp
loUkS1Zsz1lY7ePrVf0Wzrgb7aqpl822s3gAatwJA3KcTWf0Hb8VbPMspb0F6wzz
qXomOS7QUattqOyZjZLdxnDUjgbUpD705f2KpV9A0jnIhzt0t5EM+Q9kg5OlhNi9
SCkNYvET7VltPeazcx/F
=cG8q
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
