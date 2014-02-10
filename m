Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaBJQgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:36:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40147 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBJQgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:36:51 -0500
Date: Mon, 10 Feb 2014 16:36:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140210163621.GA13533@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-15-git-send-email-richard@nod.at>
 <20140210114154.GQ1757@sirena.org.uk>
 <1392039072.3585.15.camel@x220>
 <20140210141255.GI1757@sirena.org.uk>
 <1392046242.3585.41.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1392046242.3585.41.camel@x220>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/28] Remove MACH_SMDKC210
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 04:30:42PM +0100, Paul Bolle wrote:
> On Mon, 2014-02-10 at 14:12 +0000, Mark Brown wrote:

> > Yes, that's correct.  Now, like I say think about what the symbol was
> > there for in the first place.

> So, next step: the Kconfig symbols MACH_SMDKV310 and MACH_SMDKC210 were
> removed in commit 383ffda2fa ("ARM: EXYNOS: no more support non-DT for
> EXYNOS SoCs"). That commit was part of v3.11. Correct?

Indeed, so we can see that these platforms were converted to use DT and
the symbols were removed as a result.  This means that a good fix here
is to ensure that the driver can be used with DT platforms.

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+QACAAoJELSic+t+oim9gcMP/26leZ6LFzKPlv9jOvbe82Li
QVHEq7Gt2FfIDYJjkiXYy7UK6HKB5xZ1PUqxVJy2ExKqEGz2SwkfYgN8uLs16R8z
7AHO86PluSecrq1P3hzLxQ2BRia45eoiSpujCy3oYN13RMiHUq1MrrUp/LlttJnT
Y++oA0oxoeJAPL+iQYJWDuRZGmduoC3ibdtXOs51eaYBCijhqs9u4X6pTZo0VoGE
V3gu2Idya9ocyQ28KipNvpG+cFjaYna8evj8MGb7vdCUHsQxg2eZZWBsvudpBo94
jYzjMekU8sQN+QVbFTt+MTsxd/wndqCJXMuiwHdQ3SvzusmeOHcSDcOmsXfyIy6C
hZFE4pNkMnekMM8ZjPTy073lFyky9GXg0jHn/amTE0e3ouGEPAaZgHY8Lv6FLgoz
3bS7ZFV3phh8Fjr/DrX434hiQC8TLTkdWbmaOTJJAK1lQbeENMVX804UfUttkCE4
QZK2+har0qUOzgTl26hJz2osPAWZSE7qo3UmdD9LWqGMx1DQ1KVDDFj5hCUoXRkz
LjYtn16rFYTCTSyao/Mp4eg5WGEawrBWYKXK7PZWDDH/89OAsnwuxi7HI9cClnng
yvhRG2rMQYUvtw0xMmTJWbTYJV0nowzA/x8D4EKo9obNu0ZBmrdMY5lTFNFFvWCZ
WWCorlRxgZllBsQetG3W
=Xxmg
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
