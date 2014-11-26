Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaKZUl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:41:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39802 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaKZUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:41:27 -0500
Date: Wed, 26 Nov 2014 20:39:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141126203921.GA7712@sirena.org.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <1415180871-25293-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ppnyhArmEF+be6aR"
Content-Disposition: inline
In-Reply-To: <1415180871-25293-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/3] regulator: max77686: Remove support for board
 files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ppnyhArmEF+be6aR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2014 at 10:47:50AM +0100, Krzysztof Kozlowski wrote:
> The driver is used only on Exynos based boards with DTS support.
> Simplify the driver and remove dead (unused) entries in platform_data
> structure.

Applied, thanks.

--ppnyhArmEF+be6aR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdjp4AAoJECTWi3JdVIfQoTkH/Rx91Lu+wbVZzuDkZHLPAr2P
O6D8x2B0cTnV5d8A0ebI2+l948CMKpQJ5+nMagIhHMgx3IPM/u/6VqaYuyMaZ1yA
NAADYtyd+TuMy4jwozaQGteUEQ3Qwx0l903iuupwCQzUGdthgz0BJ1e887nJTgVI
Dzylmm89EATOc6ccltewHQF+TNEJClpkVERxuFlwAP0ap37bINF1vnP1IrhnwMEO
k+SAVjQZ0IBiXNjBQ9LhGI86BUCSVxvc9v9lz+F0BBAMFpK6Zegykbutyrzbp5A7
TdAHpkzE8DpDmhWWgIPr8JB4zYV1nxmR+HXCJHLjbI276xvcSleXbeYyamjzTMQ=
=3Dtk
-----END PGP SIGNATURE-----

--ppnyhArmEF+be6aR--
