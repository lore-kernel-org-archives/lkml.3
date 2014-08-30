Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaH3SY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:24:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42096 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaH3SYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:24:54 -0400
Date: Sat, 30 Aug 2014 19:24:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, heiko@sntech.de, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140830182404.GC29327@sirena.org.uk>
References: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
 <1409350196-17784-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aHyShe78FfJzbeER"
Content-Disposition: inline
In-Reply-To: <1409350196-17784-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] rockchip-i2s: add power setting for I2S controller,
 also fix some bugs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aHyShe78FfJzbeER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2014 at 03:09:56PM -0700, Jianqun wrote:
> changes:
> * add snd_soc_dai_init_dma_data
> * fix duplicated argument to "I2S_DMACR_TDE_DISABLE"
> * set 1.8v or 3.3v power for I2S controller by GRF interface
> * enable "hclk" always
> * dma maxburst change to 16
>=20
> Requested on RK3XXX I2S controllers, and tested ok on rk3288-pinky board.

Please don't submit multiple changes in one patch unless there's a
strong, specific reason to do so.  It makes it very hard to review the
change if there's lots of different things going on (in this case
there's also some coding style updates that aren't mentioned in the
changelog which doesn't help either).  Split the changes out into
multiple patches instead.

> Change-Id: If17b8022a38c2974f32bfb2dd4b8d16644ec57ac

Don't include noise from your internal review system in upstream
commits.

--aHyShe78FfJzbeER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAhbBAAoJELSic+t+oim9L/UP+waZzC2nnAKuXgalswRZorRW
gD+UBGesinIsvNLvBXjOUpQiorerMXKxtzssmxzf8ha1ryDb2nOuXEZX3SWGKWae
9TWlKqfH/e0mnht7HK6aTPOVFBGF2c3CLOqRZ+6gi/TxcpsnYicyWdH/WKB2fJnZ
yPhXbk2mjdbo5qtPa+hzs91OesMyYS9yd1d1r8QrWYOIvkudmZ0Q7yllDEW2q+KW
7FEaIkI26H4sfeD4x/RiOYTWaS5kuK0rtHm4Li2xZ1Lftnq0FRmfv9NKtZshQw81
OXPys6viSUif5cYOs5FDtJL+CxeqDHtPLRGA5MSsMPU8yfXHWkVX9HBxQz3x5Oot
8TvAd8Pa8eEydUW5xPl/f173mGal1mTQ7v6T8bkw6PRVDP8r0L4MZpeCAHYSXTP5
YhjUJ4ORO1RcltBb2biKedtpdJ6xmo9WKU3+hkzjAocA2HuAhcF8SxQuuS64QTVn
y3Gna0vxenUs0n5s7FWJhGF8JVYQymuK49ih/hsZqZpFazX2glt/OaXrGFDcmU1c
u4H54VGsURPX8wOkYTedPChWOjJnCWqcVoMEL1ctySMLQUO2OzfErlQifzn1CSCR
DmuLXP5HEgnwhLD0dOB4PFrH/Edo39lehNGE6yVmAyTSeyiV7vmKdjFnZMj9B7Uw
8nOc5ix5DgcrNHuyrK46
=Os88
-----END PGP SIGNATURE-----

--aHyShe78FfJzbeER--
