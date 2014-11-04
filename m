Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaKDUtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:49:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37959 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKDUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:49:16 -0500
Date: Tue, 4 Nov 2014 20:47:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141104204759.GF3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415090986-30623-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uDFvSQRiMrFNsvdR"
Content-Disposition: inline
In-Reply-To: <1415090986-30623-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFT 3/6] regulator: max77802: Don't ignore return value of
 current opmode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uDFvSQRiMrFNsvdR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 09:49:43AM +0100, Krzysztof Kozlowski wrote:
> The return value of regmap_read() of current opmode for regulator was
> silently ignored and whatever happened to be in 'val' variable was used
> as new opmode. This could lead to using bogus opmode.

Applied, thanks.

--uDFvSQRiMrFNsvdR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWTt+AAoJECTWi3JdVIfQcfwIAIEwLK0qGKZLFpA1xgZeio8I
cccapI7EvMWPaCxLOb/57bDpUlsGkGCuizZpkvJVxEOjBsDErRbtrtJfvlQK0WOe
ysQdJjy3/BkfuXpnNOOc7BeY7AGmzKEokIiDzH5S27HPQ2PxldF9NcnpHUfKIuvk
VcGWtzR5ZbGHQRMm/WkO6AnFqHtjdPFBNJgtbPDjXM3VfEA8L5paqXC8eJ4FHR2R
B03bxVQs0FZHpt72p+ffGT4R8ZKKOcyPMHKJYQoliTCgd0AgL85d0qIutimJRAlw
1c4C5eSX8iC+AcinNJJeU01izz/sY5Z4U2eyun38IbHIiSuXaEb24Wc3fqXx4Jc=
=haxl
-----END PGP SIGNATURE-----

--uDFvSQRiMrFNsvdR--
