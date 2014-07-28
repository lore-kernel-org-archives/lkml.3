Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaG1VaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:30:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60129 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaG1VaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:30:23 -0400
Date: Mon, 28 Jul 2014 22:29:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, s.hauer@pengutronix.de,
        fabio.estevam@freescale.com, kuninori.morimoto.gx@renesas.com,
        Li.Xiubo@freescale.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140728212957.GG17528@sirena.org.uk>
References: <1406527864-22092-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZYwxBGyy4rg4AI1"
Content-Disposition: inline
In-Reply-To: <1406527864-22092-1-git-send-email-kiran.padwal21@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: ak4642: Make of_device_id array const
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZYwxBGyy4rg4AI1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 11:41:04AM +0530, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const

Applied, thanks.

--4ZYwxBGyy4rg4AI1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1sDSAAoJELSic+t+oim9d/gP/2zKo2JdEWh8BpV0dUOnvSx5
as8Wit+TGLzNkVi8sNCxPn1hfYS3actOC8uJpDSU3mspYXNowi4nnlcYUE9a+duq
AmwRg58GN2tVDiie5Av+hye8Z3z4UH3kNjII5QkUlBPjHP9KCbNRX52rtV1islbE
XMNeLumGIcaPHUg4M7QYGV6UPnlQJw8BaSKTMb9iJfftKytemkxC9vmPRqwJM3ai
HBb6mGzJYuSDF+4iuENTB6Vw1wbULrfa2pJaOIg46WgCB0XyA5DJCysXZJYLgFwy
MsxdQVqhsgcFKVw1+gLFrFY3LgLKyl/WyyN25OWgYpa+N2LZpM9KWvunWx6LoTTx
mV1TjyD8/VgRJUxF956XgLS+gMil9uQ7r5EFMtjo1Gk2A6lHV+XIu8p0Z+EmEX2f
koriGqb1xG0GlzJM17IBDSrnRKtzM4HIDYHFzeMtzBalIDnhtqxXkfF13rvXcgja
oKMxHW3sPuged1Pk2uYmB1NvScepk425ZQpo9PjUrVMWiAkdsDQ/0fEP0Dnk5GD5
DtK2Rbv5P9FprXpU3lzNpJ2IGPmymToYfQ2a9rcDxMdEzEU4ISlnPys+/TL/eKNo
+Yo1zmOzzEC0yV7N4GhOa25XKrDcIEYwlkynHZK9MOEP2oGnnqzo1PgV0OuK9a/Q
MGKU2PaQpS9hCdWyKgeA
=SDSD
-----END PGP SIGNATURE-----

--4ZYwxBGyy4rg4AI1--
