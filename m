Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaHUOuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:50:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53174 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaHUOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:50:22 -0400
Date: Thu, 21 Aug 2014 09:50:16 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Guodong Xu <guodong.xu@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140821145016.GI24407@sirena.org.uk>
References: <1408588293.10818.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9wgEzdE/cOoYWTWe"
Content-Disposition: inline
In-Reply-To: <1408588293.10818.3.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: hi6421: Remove unused fields from struct
 hi6421_regulator_info
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9wgEzdE/cOoYWTWe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 10:31:33AM +0800, Axel Lin wrote:
> The valid_modes_mask and *dev are not used in this driver, remove them.
> Current code uses devm_regulator_register, so we don't need *regulator in
> hi6421_regulator_info. Use a local variable instead.

Applied, thanks.

--9wgEzdE/cOoYWTWe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9gckAAoJELSic+t+oim9d3cQAIgIALBoH3QXbCna79Rvst1f
pXR0xIHYyg1ZbhQ5/mqvJw1Wn/cJycE7f8YDADL6yMVq1L5RDSsdrmzxbNEm/JDc
dWZ0vtrQ34THf3W5MLUstz/2SRvq+nDS7p2NyNF9ssv+Os/qZRVssAAOxaW1rms1
LUIjyaLIWyI6VuLHOtyt7QG8Caz2ywksAxP6iANFA3OXKpN/gDu1KlzYVJdnUA0G
L4ZWQEXQB5mAiDwSixSHrYqyLfMqq26os/YBo2xpLTYrrc36MkCFNtFm9+zmyYLb
rAv7SJ44pMsvj3B/y3yhBzXHScsZXt3wJ2oc5pcjVEnjYH43q/qdjKM6lYEl6jdO
1GC6B0r+et2bwbd+9anED+DWnB63+HY2QyF7ByEwFrCEqmF5eWZhfWa6gNsMgcjR
3oDPSSi55yl7hamnPqIxASPc4vfCSvLEuCSR4t4nR54lmkwjpHRJuFHKjwfm09VX
JlTi1Iv492Mf6I64/SajjLTK/h5j1SRv3EqjVzX6Em5JtuIAbDApH/q5OpMmx+Pr
ZWAvMXo1dRbZpaFc5+iSZPlyte3fk6jf2PPUiogCi+LjqCE6m7IB9jlxdjFN0Ybi
vm/ZaJfHYwdnbLIEaeEjXkknqggIExrmR3uXhg2TKrh6HMA5Zlq+APxHfTEzmydJ
x8LklRcz0D9phgXcPNcu
=K6yP
-----END PGP SIGNATURE-----

--9wgEzdE/cOoYWTWe--
