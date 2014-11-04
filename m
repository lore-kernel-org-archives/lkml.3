Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaKDUsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:48:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:48:11 -0500
Date: Tue, 4 Nov 2014 20:46:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141104204647.GE3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415090986-30623-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aomzg3EM4pKutSJj"
Content-Disposition: inline
In-Reply-To: <1415090986-30623-6-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/6] regulator: max77686: Remove support for board files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aomzg3EM4pKutSJj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 09:49:45AM +0100, Krzysztof Kozlowski wrote:
> The driver is used only on Exynos based boards with DTS support.
> Simplify the driver and remove dead (unused) entries in platform_data
> structure.

This mostly isn't actually removing platform data support as far as I
can see?  It's removing some spurious error checks for missing platform
data (which is good) and converting to use the core DT parsing (which is
also good) but just leaving this:

> -       struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);

> -               config.init_data = pdata->regulators[i].initdata;

would keep platform data support there.  What problem is removing
platform data support solving?

--aomzg3EM4pKutSJj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWTs2AAoJECTWi3JdVIfQtdkH/2b7Ljbq4ZYFN75GN5xqHeQZ
iOkIUFRBjIP+I+Zfplbn3eGlkf9waUbSP6KjOQZbuMpGonAJc5oPfe+mxduMTntH
GMZKbcGXzWVoWzDGXwW5S+LEMtrf2rl8MH6BgaIC84dnt9jFXuSR3wKS2/6bIvUT
t9IsnY5y+S5ee6nqV+sb+U6Hl+pqxF3bQkiloPRq5LDDBoF1mUTb9nwxh38zfga2
cWiW5YZ+KxlGoJoU7UpLykCac/lMzMCrLKEHgWfVJh2r98zhwAly6QVQOX77wOvf
yTqEXjpSh3XoVqklK6YP93OC7vvvQgwOhAnqI8H0RAN4fW3SVoca3/fPCv6UGNU=
=89L5
-----END PGP SIGNATURE-----

--aomzg3EM4pKutSJj--
