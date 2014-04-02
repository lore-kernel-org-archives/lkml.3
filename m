Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbaDBTyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:54:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50486 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbaDBTyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:54:22 -0400
Date: Wed, 2 Apr 2014 20:54:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140402195408.GO14763@sirena.org.uk>
References: <1395389720.29259.1.camel@phoenix>
 <1395389784.29259.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ7Ovc9/RBrrr0/1"
Content-Disposition: inline
In-Reply-To: <1395389784.29259.2.camel@phoenix>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: s2mps11: Don't check enable_shift before
 setting enable ramp rate
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ7Ovc9/RBrrr0/1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 04:16:24PM +0800, Axel Lin wrote:
> Current code misses updating the register when enable_shift is 0.
> e.g. S2MPS11_BUCK9_RAMP_SHIFT and S2MPS11_BUCK6_RAMP_EN_SHIFT are 0.

Applied, thanks.

--rQ7Ovc9/RBrrr0/1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPGrdAAoJELSic+t+oim9vf4QAIzDAcvcpB4/6CgUuNKwoUOb
DgEuG5IfbV53BxVet1poezvGfPfwwEGCa14yJkctc+ox8sKDnapjSBWCiFH3z47y
/xhsr7uqGbmuTwZeDYlb1rDWh734UMfZcFIPVpjl8enXeYNAAxt/5TOoAuWpLeFQ
tgW+iVuy9eQHCoz1L/AuiTUMdEfbQL35tFuxUskKmARlpCQQnJu+RaL8yvBzqxaM
eEoa0/9HNMUsb3JC1AOFYHg2+zFweakiG1e41i9zMdKCi7rtAh8p2akTFDzHOj/O
hDP/c1bjgCVp4LuDoveI439AE0j3ZBPcK2mNGFcuYf/ub2UmG9sxariLEB/77guv
0SKNIg0dQ4Enk8lqNYSYlrfgbArJ8RgITK5TWnv2sDoE36zElrFkVzROL/lPFRb2
KJDlgqlxqYzmdOgkluXCMCRn1imaQFvlb893QG9fLfZRPtF1/AAB9cK8ALlnSMeV
rlitUgkvCctxPWrveYqOmQ0H9gY6fADX4LJsoWtsDtZk7kblv/Ne5Y5DG3gDnO8z
T3wMX/sa5Q9B4T+vzG3uu4l/YCNp1lFMH330xCncA848mdbRArdNOciqFbnqyb5B
DiNXdxA9NUZM5I3mB/4oNHUH8NYVK2qbh1sUFuZ/f+BLULiowv977tcKgK73dkvx
qZLqsTXw9dc22pv8GN48
=g97J
-----END PGP SIGNATURE-----

--rQ7Ovc9/RBrrr0/1--
