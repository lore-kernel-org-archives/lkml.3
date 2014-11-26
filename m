Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaKZUkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:40:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39795 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaKZUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:40:32 -0500
Date: Wed, 26 Nov 2014 20:38:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141126203824.GZ7712@sirena.org.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <1415180871-25293-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MJ852bKmue9FasDc"
Content-Disposition: inline
In-Reply-To: <1415180871-25293-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] regulator: max77802: Remove support for board
 files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MJ852bKmue9FasDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2014 at 10:47:49AM +0100, Krzysztof Kozlowski wrote:
> The driver is used only on Exynos based boards with DTS support.
> Simplify the driver and remove dead (unused) entries in platform_data
> structure.

Applied, thanks.

--MJ852bKmue9FasDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdjo/AAoJECTWi3JdVIfQa+MH+QH392J0lb8kW58MJIy6lLAF
WejSRC7uuqSqWTAKn2pApFUBQCiSV+YI+pnH8/Fc/6C0YH4HMJf2H4OC5sT6eiC/
9JDWuWxxpILpgYgd5g3IWV13Awy7tfpsnRQXwiAIih/wN0+BsdTJwivUY9xvXAdU
13SREbPlf9ZaMQMPGjBI2rvOiyBOWK/bdnbiGCyVf16r+BTTq/R0acskYrKrmye0
IA5lEfIHzPOT3EIpbfBUWBMDTSuGbpDwXgDVdnwlHD8x5IT94EjBTvbkt/sg/1C+
DLIQumiGrc1sEploAQ/XKSVqIk8Jn9WmI8woB6i/QJlNTsFsBpQl7jPg01jfir4=
=58+G
-----END PGP SIGNATURE-----

--MJ852bKmue9FasDc--
