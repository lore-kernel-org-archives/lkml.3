Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaA1QZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:25:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaA1QZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:25:47 -0500
Date: Tue, 28 Jan 2014 16:25:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20140128162532.GQ11841@sirena.org.uk>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-16-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+H7+ogK6c4CMxbzj"
Content-Disposition: inline
In-Reply-To: <1390911522-28209-16-git-send-email-k.kozlowski@samsung.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 15/18] regulator: max14577: Add support for max77836
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+H7+ogK6c4CMxbzj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 28, 2014 at 01:18:39PM +0100, Krzysztof Kozlowski wrote:
> Add support for MAX77836 chipset and its additional two LDO regulators.
> These LDO regulators are controlled by the PMIC block with additional
> regmap (different I2C slave address).

Reviewed-by: Mark Brown <broonie@linaro.org>

This should go in with the rest of the changes I guess.

--+H7+ogK6c4CMxbzj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS59n5AAoJELSic+t+oim9jy8P/2CGYEEtI2r9RAXJtd9Ehoti
r3RIJbbmADQ1W+jq2bRvDvpUGfyqepCL9YeKRHns8AZ43W867IJwN0zPsXAcWnRA
JrnAOQfPQwR8uKElqr3gxDOLHrHJ9wgR4HgA8uy0/8srnplqvb3W0E/jtoh836eU
6M82sIm9jSKv+5mP0uF/aNcmFbKbEHVcfW4R7IuidUoc/eJP2RlCEWZmkLB2Zv57
OcSCGn/32NCuMSavorMHwZ7YCFRU8jIZQdYzH7LLYHTCnUr4PHBLGLXi5srqZSDR
Wn49tquP2ZBnN6yFAW9Yv3I7scZAwmHN8rXgEPbD/dxCumRnHZVgfDcLLjjoMcgy
b1QPLH1HTdd1kPrCd8ADRoaaVS91gRqHJdzFYyFhsRLLrROtYrVGP3VardczmL7q
ehx/AOUqCnEmfl/chcSNR7TGG2U8HRHrXKKqL+xyhutR2wFHZIT0OkE/Uuao378n
uXs8Ge+Rg6inTREeBcYR5NCCDEC1utWPfFutDN4lnNND8aCah2q2GI50LgnuSUt/
DeCVw4fA3+GtZU51RuTvbQky1sR5DJbe+zbHJHLygjkBPzl5JEilLvEW5joMtwmS
HhMVAG/Pq4M2o6VTaButx0YpSEcPlby/DQHmRkHwpLpDcOcvM+d2H0J1w/foecwa
k0LXMx2DEXUVLnuGHh2r
=M73o
-----END PGP SIGNATURE-----

--+H7+ogK6c4CMxbzj--
