Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3HCQby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 12:31:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39690 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3HCQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 12:31:53 -0400
Date: Sat, 3 Aug 2013 17:31:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20130803163137.GS9858@sirena.org.uk>
References: <20130731081739.76aae84c@armhf>
 <20130803123954.GX23006@n2100.arm.linux.org.uk>
 <20130803175513.7b765b0d@armhf>
 <20130803161029.GD23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BNH/31tu5pBGcZBM"
Content-Disposition: inline
In-Reply-To: <20130803161029.GD23006@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/4] ASoc: kirkwood: simplify probe error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BNH/31tu5pBGcZBM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 03, 2013 at 05:10:29PM +0100, Russell King - ARM Linux wrote:

> having to run around and pull random trees.  In other words, you should
> have Cc'd interested parties on that devm_* change patch - especially
> myself as I was the one who introduced that code.

That was me, sorry - Jean-Francios had nothing to do with the patch.

--BNH/31tu5pBGcZBM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/TBlAAoJELSic+t+oim9sgIP/j4p2jvBvvUS7RamPmi/pgQm
GQqti1R2zjto9Str6XBKuqE8uAGn46qtHs4kGQTImVSb2uOEy/PhYrRaF01X2p04
Va5IDvkgnAR660SGX8MDYQZsD7X4XsKClG4LibxPFXs3ZYOCrNeV9tXP0gYzeMXb
EOLJnTNm+b/ahVJmlhlrDwv0bTafuO1HCrHUkiBzTLcEUqJblxL+g3PJmGVkHSY+
+lWSRVdLiP7zbIh6jwB3c8X0a7igjYAcYeRVWnRaByDKpmrr3c2K08WX9tAhHtLt
DEimRsBoRiOb5Ov4xSfom2OvygDzQ4H7b5l2jL/Wg+/37pKu+5jkIVq2UFc19GWB
iWDwPmz+TZ9SvX1l4XCUNnBE3GxxlHbPoXBwVLSl6fzWNnKgiDsfYMyKWuHDT9ch
2hUV0wHBQXNQ5ZJrAs+eGSp1PDLHu98NsosNfyBZYGx/F1HZhifpzgawomCPPa4a
lXqznH37z+MrRdgnwSkUgSMi47s7kaJOtQiLZzATWFHJMw2YEizItx7+p72rq+Rf
qJH47PJXXVfhZgRFpQsGJOoG5AbPFZDbDrkEmCCJNwrh7jF16yFWHGIpLWeOg7qm
zh2vjgvNtyMQUz4duAQda5TOh1qu72zsO3ACW7EEuQXE6aiQLBix57i2IykDm0EN
UuPMStlRE0vCJb12mx85
=ZsFY
-----END PGP SIGNATURE-----

--BNH/31tu5pBGcZBM--
