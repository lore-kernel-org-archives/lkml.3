Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaCDDWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:22:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55015 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbaCDDWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:22:08 -0500
Date: Tue, 4 Mar 2014 11:02:30 +0800
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140304030230.GV2411@sirena.org.uk>
References: <1393862031-4896-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69FgzCUgmxT1EUzs"
Content-Disposition: inline
In-Reply-To: <1393862031-4896-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Fix section mismatch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69FgzCUgmxT1EUzs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 04:53:51PM +0100, Krzysztof Kozlowski wrote:
> Remove __initconst from regulator_desc array because this array is used
> during probe and s2mps11_pmic_probe() is not in __init section. However
> still select the number of supported regulators according to device ID
> so the driver will be ready for adding support for S2MPS14 device.

Applied, thanks.

--69FgzCUgmxT1EUzs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFUI8AAoJELSic+t+oim91OAP/0ZCPh66vWuGtfDwFub/9bGZ
gKISFicToH4nZSXCkJJ2VGKpK9S1jQfic8QNY727WoC95Jk2PNOiIE1ExIiVIVLF
6844uLgDwc65Vj76wn0kL2x8OhnMZxxlr7RjGxyiJPTKceR1QsAz8GZjKvf+rkOA
zcYSFGPBRZCLudOOoa4D0VQZ8m1J+dBSQNjXpI5MABcWvS2f55moGd7BVtlw1pQY
uvKEG8ooFOaHzfxcltx0oKwWtxuGzaWo8oiRK6RmtzHpbY6F4QHCx0QdPrDSqg+9
ZvS8SGe14DnVZJZNWXHBrfHd6jUduzb9um3xyhvrFAUcHnIhnTUUlh764c49sf4O
uoX0pVPQf+hA7LWF07oTO5isDXYnYJLJv5ydvMrEAyyd3LZp8RHYEKILlbHcpWrv
+Mb3kzlbRI8I+1kZy0Y00Doo+RCZaYArWlvEj9+lf4GVtFMWQhf6Yu6ptX3UIzN/
kuFjj382BLxca3ucoZMKbZjCLKICF/OXJ9W+XSFEoiMZ5xQLyphax5Ol2AaiHHZN
3AtOGS0dk64/qZAKILWi1WqhfRPsP3sDcql8D83NgN856gPTRRN6z85fxZuWUYH4
YNwSZbkyXYPWR7jdnWQGc+JzjlKiv1oBaCU3bThE3iM7051T6Ktqv97kYpeY7khw
YZuVJnhjSJwcVOcCXN3U
=60lb
-----END PGP SIGNATURE-----

--69FgzCUgmxT1EUzs--
