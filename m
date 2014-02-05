Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaBEO7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:59:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36328 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBEO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:59:51 -0500
Date: Wed, 5 Feb 2014 14:59:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140205145924.GA32298@sirena.org.uk>
References: <1391605507-30981-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391605507-30981-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <1391605507-30981-4-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 02:05:05PM +0100, Maxime Ripard wrote:
> The Allwinner A31 has a new SPI controller IP compared to the older Allwinner
> SoCs.

Looks good - applied, thanks!

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8lHIAAoJELSic+t+oim9U0YP/3Lp8IvFOsSfD/Aj41cjxW5I
ruD6tVrOyJkmQnONj4oPatHhvclOZdiLIYYENpXWbSHhMttV6ng65Ct6kFrxa054
3iWVOsmGNs9sjYd+oCWYwk097+pKqPB9skjJa7+AXXU6IP9hkAImTsHPhQtCNmTW
1CQ96/tW62miZtBkJ+UE+iunknayYlsAFJ9AsQ9tBrJ8fRaapfOwOJ3NU5jFkbM1
Tuj5b9b932rVJEZYZn0/ZdoqdDydhwq5Ql4FpXsqPNYRukuDatI3eU5Yx+IKmUPT
VglqIfNYk8Rk3Y+x370sYfadGp/ojgczAcCbm6oSMsk3m7ABT8oAaaINb1IvY2bZ
0F8QmvDRpLnePiUnMGsrZLc4KC4oc0M1Xb1DOPQDe4xL1jo89dbQryjc4cYPJuwR
7NucvvAkqFVBAML9w8Nc2VQAQuhOEyJVlWuA2JzcxOku9+fYT6TekSa86DXXGgst
aF9zLHdPQfXiO8gDhFf4Q7pwvspUVyBM0KfaV4y2OSiGhfIk4BqwfDJ013/6RW6E
Vt7D90f1iFlTNRuHrbKUyASyAyOCnEVKsU86mRoP5N+i0gxtlsabIC3NvWneiPGV
jM1wIx8P95W30LsHXCINo3Wwrvqwr5PO53HfYOXUOlYcMbXVuYnHorjUI0dJsDCF
FyIoFTZI7qrbSOAAr9QF
=D/De
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
