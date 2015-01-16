Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbbAPLsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:48:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38681 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbAPLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:48:17 -0500
Date: Fri, 16 Jan 2015 11:48:09 +0000
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20150116114809.GI3043@sirena.org.uk>
References: <201501160315.t0G3Fix5023568@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p14GW7TY4DvKqgVo"
Content-Disposition: inline
In-Reply-To: <201501160315.t0G3Fix5023568@krsrvapps-01.diasemi.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: da9211: fix unmatched of_node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p14GW7TY4DvKqgVo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 12:13:27PM +0900, James Ban wrote:
> This is a patch for fixing unmatched of_node.

Applied, thanks.

--p14GW7TY4DvKqgVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuPp4AAoJECTWi3JdVIfQZCcH/iQ0WImdGqNIMa1o3i+HCr+W
WLYRahZG+IPyuCcx4QsMEes4P+vbYmuPgDycRTfrpK8kFGiW/V7CHQwjrN47l3cZ
eePPmYJ262bxDI1IRVqHy+A7n3PXKO/dfKdqIxXnWORq7wbPMQloEzIrjmuwMyvK
QP91qiqSBtTy0ejFVMdtrv2Xw3IjjPdAF5u1y6adoDEIL84Vu7FT0/FO0692wMXo
h+ld42ufhxyBgAPw7KlvLpF/DNMffTBdsTUY52JLq6tk9IK8P2aMhUrloI6A84jr
LmF/PZUouMop5b6DPtgsWBn8WJzRi0Ou0Um1EezBKWc+Mib8TEIJu38rMzFxMTg=
=CMda
-----END PGP SIGNATURE-----

--p14GW7TY4DvKqgVo--
