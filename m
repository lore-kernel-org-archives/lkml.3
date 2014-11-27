Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaK0NFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:05:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40829 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaK0NFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:05:08 -0500
Date: Thu, 27 Nov 2014 13:03:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20141127130301.GX7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OyvoBEGRARVUNgID"
Content-Disposition: inline
In-Reply-To: <1417087253-12306-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/7] mfd: max77686/802: Remove support for board files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OyvoBEGRARVUNgID
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 12:20:47PM +0100, Krzysztof Kozlowski wrote:
> The driver is used only on Exynos based boards with DTS support.
> After removal of board file support from max77686 and max77802 regulator
> drivers, the MFD driver can be converted to DTS-only version. This
> simplifies a little the code:

Why is this a dependency for new features in the regulator core?

--OyvoBEGRARVUNgID
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdyEEAAoJECTWi3JdVIfQvlAH/2uI9u76rfQSrvibGcW40bC4
TXugFJSI9ZTqjRDu/b4Np5axJ10YaBd38I/KcOOp3gSrMf55NuJLbdIad8h1tv0R
u6tCUwlBZBodj7hVbUSk04GP/wXhxYtVoz0W+gnrrwXwyf+aVGil8N/75GdpNqFs
lQkVv8lSeqQBpzYLBPTyLHP96InULspDMQMFM3GNL2x3QkKXxD6UYWseTUeKnQLg
XLYf44ngTwTOmCaCGH+x79L+YkwH2C383y4g2dUM9SMAQQ8QpVXz4FWPW0HT9aWL
oa8t03T9AimjQJM95Z9C01nmTppRLabWD7nPfbPZrLAAmkHO+9Jc5FC5ozYgZWU=
=7jjJ
-----END PGP SIGNATURE-----

--OyvoBEGRARVUNgID--
