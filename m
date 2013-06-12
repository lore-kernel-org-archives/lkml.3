Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3FLQIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:08:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60602 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3FLQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:08:38 -0400
Date: Wed, 12 Jun 2013 17:08:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Oskar Schirmer <oskar@scara.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <zengzm.kernel@gmail.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130612160805.GL1403@sirena.org.uk>
References: <51B71608.3000302@freescale.com>
 <1370964151-6728-1-git-send-email-oskar@scara.com>
 <51B749F5.3010907@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LIxvNfiQb+4m9exP"
Content-Disposition: inline
In-Reply-To: <51B749F5.3010907@freescale.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] sound/sgtl5000: fix codec register initial values and
 mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LIxvNfiQb+4m9exP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 01:01:57PM -0300, Fabio Estevam wrote:
> On 06/11/2013 12:22 PM, Oskar Schirmer wrote:
> >According to documentation bit 3:2 in register SSS_CTRL are
> >reserved and zero, so initially setting the register to 0x0008
> >does not make much sense. Instead, bit 4 should be marked set,
> >as this is the power up default.
> >
> >Further, mask computation in declarative part is obviously wrong:
> >Fix FRAC DIVISOR to provide an 11 bit mask correctly.
> >
> >Signed-off-by: Oskar Schirmer <oskar@scara.com>
> >Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

> Looks good, but please copy Mark Brown. Just added him in Cc now.

Please also use subject lines matching the normal style for the
subsystem.  I can't apply this unless someone sends me a copy properly
(not quoted and so on).

--LIxvNfiQb+4m9exP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuJziAAoJELSic+t+oim9MrUP+QERA+7zk0FbFa95mKR7ucqB
4p5XUWKYDaCXhw2+ykqpd3dCSsSVZhbVvsC2Upx6uZAlPX79YaFP85eEf20Y1zk/
JAI8V82k2qBMzrMc9iYPKrkfN+MBmeADDy1/3d+BTfmB0t4ts/r3MFukQJ/w07oI
DQAClwRP01qn2xuicYOZTJYPaU3EZw7/gOMZiu/rT5UyFbnwlVsBtZOGZomfELXA
s6rCIMhypt/y98diYHR2gj3y4l3MnYrKojZV9xyr2PBuwlne75T0ujZbjgVIXI8p
4BAZPuWJH0qPQGS05mMUWvLOFah3qJr/wOuPrbR0ICNujJMhC4WLSGjy1r5u2VVz
tigMK6aJYLzTUyDPfHSPaprbsJ1DDdYVlG9pb6RkqKVCpFDUdDsuxhX2vuH9d/g1
E3R2p/ZAaowpPwaTkdiS1nugiwt2BdlYCz8PHJK7+/UjFDSeRNa/smaPmZRp7lMW
TvqPXGTNVhKSm7AcbIVrwvrh+by5y578hPkjWqR6IWbi2wt1bjflx1K/lfGrkVjv
y696R9Y4jOBhnK3bin9wKFBgH2i3zbQw3BKgnSTbQfITl7O1YfOlcXTx1tENVfLN
+E9kZnPmBNTlM36sHU6tGU6KSoUpqis/byE1za5erYXDDyJcZZX/RqCCz9yEzQYy
YEJZu0V96xjyQdCOPdeX
=qlZ2
-----END PGP SIGNATURE-----

--LIxvNfiQb+4m9exP--
