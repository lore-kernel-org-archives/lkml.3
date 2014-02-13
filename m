Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaBMT2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:28:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42987 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaBMT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:28:44 -0500
Date: Thu, 13 Feb 2014 19:10:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140213191028.GC28112@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-10-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HOIXJDerRg0rVrcW"
Content-Disposition: inline
In-Reply-To: <1392282847-25444-10-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 09/14] regulator: s2mps11: Add support for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HOIXJDerRg0rVrcW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 10:14:02AM +0100, Krzysztof Kozlowski wrote:
> Add support for S2MPS14 PMIC regulators to s2mps11 driver. The S2MPS14
> has fewer BUCK-s and LDO-s than S2MPS11. It also does not support
> controlling the BUCK ramp delay.

How different are the other Samsung PMICs?  They share the core driver
code and this makes the driver more parameterisable so perhaps it means
the others could be merged in here too.

--HOIXJDerRg0rVrcW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/RihAAoJELSic+t+oim9LUMP/2tprxbWnfGcoBkZWA9Ju7wC
V/q0p3ZxFXuyOegEwTNwymzZw6z7YyvWwTDiiPEXP4NTB1RClTVndK1zC5IX0npS
/infRE6fZvXr0ecxrjqq6OXykH9JTp4/mUItMlqZsx1BnGeMm4RwXTMRYMqr2b26
WRfy3s93o11ZuXKZaENrnS/Av+P8zL/SL4fYvP1MOPFUFozMvt9c/vUt3YkwJxiM
a7Ro0UBi9P6Ec+aWmwHOHUlQgL8Q5g6cn6TIu1q/U/LaB/wj9zgP3Y6L17dbRc0w
QGRl0CVLF4pKE1ALg9NemTLgfgbjDZAwRaQysTly55VxWgDCyrBSE+p8OBlmgQvc
DLrX1217c0sCdA2MhMChxAkSN/aWz0WvF3lSbHxJ5OeM3oo7u7GEHyJq5ikjHMSj
6uc5WaB4j5hCK1LZvBMFx3puIz8IdhVLyG0oENtqd3cvSUqtA738uVVE74A0Y2+/
WGOw+HORT36BhojCOSN5SHQlXTqSXVtBNOT0bl6ABUujmAMPcfSH37OzaQEZdVl9
i10y9+FimDr+6AesvIgbqJWIDCA/4xDbHW1jl3SxsR7M0rq8jOY95uOJfxTIvO3/
vfymx7urFt9s76V/w4xCgEP5I/N7aRZtkELb8endeRfh8PAXKMa5H9t6ljRRmRjc
NjYabPtTKsDhze+aSoyb
=RFIj
-----END PGP SIGNATURE-----

--HOIXJDerRg0rVrcW--
