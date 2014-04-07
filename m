Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaDGMlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:41:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44359 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaDGMlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:41:21 -0400
Date: Mon, 7 Apr 2014 13:41:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140407124107.GE14763@sirena.org.uk>
References: <1396872924-14675-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1n5KrmHTzI9lYhsK"
Content-Disposition: inline
In-Reply-To: <1396872924-14675-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s5m8767: Fix carried over ena_gpio
 assignment
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1n5KrmHTzI9lYhsK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 07, 2014 at 02:15:23PM +0200, Krzysztof Kozlowski wrote:
> During registration of regulators if external control for regulator was
> set in DTS the ena_gpio and ena_gpio_flags fields of regulator_config
> were set to proper values.

Applied, thanks.

--1n5KrmHTzI9lYhsK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQpzgAAoJELSic+t+oim9vzoQAIZLDNvJ216ZG6gtqA+UC9es
YAD32N7Y0KRRci4DaJbcxDk2GtOXnJnzg+jEtFV4jnzwQfLjMMDx/AD7w/09aiTY
KSJKqn1E146lW/3DZb7JoH5fgOsoG2jmImDCPg45Ml9Z4AHSj5USWxp3QRFRd0Xb
UGC800GbhYCS8iBKXJFK5j+8WIV442lswg0zKQGvgTS3L0NJ4LyxGQsR73Y6Net2
aF3/joN3qgBpPKPpMnanO7kkUSx/4NPk6GyJIVvsFJkxGFuD7lNi8BzBFJ6VDgjz
PltHcMOx/Rqmh7QcsM75e8LSsC6xgCrGuiuWaPa4T5Rcgn9JZJpziPWKe/o6quCx
x2weFGjM79nW/rNiyKVg108uy79gFkaHDR4GCQO0xgEfmMA9FsB7ZObZJG50i7R5
Xu5ITFkQDmB/KyQPSk2OBu/lg/eoty5p28h2Y4Dh1z0o6toEkdKSiZZOTksryx/A
fY914twyqO+IbdCMNkM9ONqGlW/TAe6GXwRuN0dtMfkN/qc5tWN13JinmnrFo/Zo
o6RpRKwewJ336CvuwmTHGiw9b/vcinvRtcgDh0uBT5aP1LDdDZdqhuTrDE6GbK1g
2Eb3DkIXXUUrm4AesaqFxiN7GmEA7TdVMZuMQVJT9YS3dHjFy6XIVSDLaOvy1FEx
3LpObKy2BMgu6qzTnrtJ
=de17
-----END PGP SIGNATURE-----

--1n5KrmHTzI9lYhsK--
