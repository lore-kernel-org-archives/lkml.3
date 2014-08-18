Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaHROA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:00:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46713 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaHROA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:00:27 -0400
Date: Mon, 18 Aug 2014 08:57:38 -0500
From: Mark Brown <broonie@kernel.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, grant.likely@linaro.org, khilman@linaro.org,
        haojian.zhuang@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        axel.lin@ingics.com, zhangnian@huawei.com
Message-ID: <20140818135738.GV14537@sirena.org.uk>
References: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org>
 <1408367356-2628-5-git-send-email-guodong.xu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y2illNFYgwJwqOHD"
Content-Disposition: inline
In-Reply-To: <1408367356-2628-5-git-send-email-guodong.xu@linaro.org>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 4/6] mfd: Add hi6421 PMIC core driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y2illNFYgwJwqOHD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 09:09:14PM +0800, Guodong Xu wrote:
> This adds driver to support HiSilicon Hi6421 PMIC. Hi6421 includes multi-
> functions, such as regulators, codec, ADCs, Coulomb counter, etc.
> This driver includes core APIs _only_.

Please don't resend already applied patches, if there are any updates
that need applying please send incremental patches.

--Y2illNFYgwJwqOHD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8gZOAAoJELSic+t+oim9vgsQAIac0+4CETBsFxqFSqoE4xqD
TJLX06Yw2Aain903XH2rYMxwHSfZGxoI8dbZBn+a1pVXvhxohuLDDtteOR0vTv1E
WFSh5+s3DAsh8qVQNoiii1lD9nBSl7b4ZQifySuVFBdAfL6XWnOCqYqiiT9j3dlP
pymY9XM6geDnk2/0kYLCwDh9yGVYs8Dvq7fwkb2HSJkWwyaQSJuF+gviFqpEwrpU
lc8p8av+vpHM4VYGRNDPOVKCxkwuwFMPMVpwwhu9rMfoOq8sVKms7ngGTNqt6028
+27br2/tKk42CJKN9zusgORyWcBKkJq8tkSXQl3UWC3G1O4jxosnDUet5cVDO9Ln
T77C77aZV0KPHYl3umz1SHNFDz57dbTB7gzpbtOpa8z5wWVl0W7cYBwKDXS0mD6O
k6BtJnNSO3rX8Inx5zsEFPRYli+Rougz3Wm4MtnOsAAmKF7O/18ScUeSHNCii2l4
L9GspjNqYmLgnvggdGkL1OkpywcncCDxK/qUFTgRHCK53Auu+31X7b2wfwsmbJuo
F4+0zcZddMD8mVylx8e7RT7eOJHTULcxtApYDjO1OGX+gOHw0SP0Cqd4sp7KMwmt
4W5fenCpEXlkOkP04xkpajdW+colwJbuiIUfSnFltNy32ErTq0enyQ3jHkxkf/ne
WSmkxSVi8TRlPdvay/2J
=TRBH
-----END PGP SIGNATURE-----

--Y2illNFYgwJwqOHD--
