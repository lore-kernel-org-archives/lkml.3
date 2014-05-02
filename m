Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaEBR1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:27:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55400 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaEBR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:27:06 -0400
Date: Fri, 2 May 2014 10:26:43 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Xia Kaixu <kaixu.xia@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20140502172643.GU3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <20140501191125.GB3245@sirena.org.uk>
 <7071653.m3UbztQEJc@wuerfel>
 <11471248.qyIXLf6t3H@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bnn9++8MR180IneI"
Content-Disposition: inline
In-Reply-To: <11471248.qyIXLf6t3H@diego>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 13/15] ASoC: SND_S3C_DMA_LEGACY needs S3C24XX_DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bnn9++8MR180IneI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 12:25:58PM +0200, Heiko St=FCbner wrote:

> Mark already removed support for the legacy API from the s3c64xx spi driv=
er=20
> (used by s3c2416 and s3c2443), so I guess to way forward would be to "sim=
ply"=20
> convert asoc and s3cmci to dmaengine and get rid of it altogether.

ASoC is already totally capable of using dmaengine on Samsung platforms,
we're just wating for the architecture to be converted.  I know there's
a dmaengine driver present but it needs to actually be used on the
platforms, there should be no blocker on that from the ASoC side.

--bnn9++8MR180IneI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY9VQAAoJELSic+t+oim9PuIP/RbmzG8yh1yWeQYAGCkxDpJr
wRx6IlegY+5ZZFDBznQmfpPosypvfI6Gs9E3OBa5ajIHpT8jyKI1L8cYNSLvSBP+
t3ctBnldg3GBcvzRDHCevmQbzcGVwiG5Uj59BtIlSDg682EpPEA5cnaiv4YBXMi0
xmyFdMMHPfJq7F9l/AiVqs8HikRnd11hItPVvY1m5amW6kB0h618Cwy6KoODWmaB
F3nXgz2T9UiPVJ1KI+T7SJ7fAWhD7GiglHgpNcnpNDgXE6BiM6AuinK2oPn4Vjgp
8r4JLeCO/7SWc9nGeSi16nq2X7LIZXip1r2VXqqOdfBMmHvc651hmTV7ChqIuGv6
IJLGtpbNGr7mgaq5OWXKPja2AUouQy6E7BI1l0pGcVakFSRajZtSR8vrbXFkwfjp
QXUopE9hF/A8iyyKUhahIssW8JzLstyNnlH9uepgltxBMO8KOStaGkYZeUVAsKpt
7gbe/HfFT98aLEXwVw1zZ9UUYOqKICci2teODHbpodZvEkB+G/hHC9LJVYK225ii
N3E40eg7ers6f9l5xV5BOt0MYX6E5MEinNeW0vypLrPxaK5Mw5Y4v0QpxHFWIQtt
NrfISrofliHr1MZOdTtYXNYj5hy9npki6VLFl7lnjUpQ8xkeMVdGEc/yEFLUKm9l
8/sUfXm5Bl/wU3ChA6Y8
=GVvP
-----END PGP SIGNATURE-----

--bnn9++8MR180IneI--
