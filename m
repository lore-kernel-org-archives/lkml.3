Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3G2FxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:53:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59080 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3G2FxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:53:01 -0400
Date: Mon, 29 Jul 2013 06:52:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130729055235.GN9858@sirena.org.uk>
References: <1375071569.4147.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9OLhvBqktUnNquIT"
Content-Disposition: inline
In-Reply-To: <1375071569.4147.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100: Fix module alias prefix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9OLhvBqktUnNquIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 12:19:29PM +0800, Axel Lin wrote:
> i2c drivers use "i2c:" prefix for module alias.

Applied, thanks.

--9OLhvBqktUnNquIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9gMgAAoJELSic+t+oim9olkP+QGmu4VGcQzSaAcVH07xNaKo
VkeCRhcz9qzlFdxsVtninihKrnrV19vY6XexfeXgf5HuvDAMYrvGFGMf9xlLzKCc
La6QPzRO7KMFsYXeOAhJrDqhgWjrXaGmqGx0baHjWO2l6yqbh9PE3BKlNZJj+ofq
AJaulNZzMDN5Ca8dwyShS913h07obz2wrhR1pHVe3j5Ek2vi8RrTMMFiwfOZpY/x
/wK+Ny1Sq4QOpU89irxSNFgSP4nR+XLhl4C6JOH4b34wNEWHg1ROc5sAezAEDJRA
Pj8mf8AOu+NSEonRBXXC4iLzboZmfkxaME/0iY5IGJZyn5/eREAGAPXi03lxp+xp
pEpLAVAO2b+ujHxOEkT2vOQB1JT7baQ1z5f0HKH55B92uySXmrf0mepuTsO4979Y
xoWwGXunGcXA8HavcSJtEM9039DfUNO6XizamsyRrXC5jjJtF/RgfiXunTg05/wu
giwrcF8+p3cTT2vAJXKTPsjUiJMzW0zAlXUBt/BWStwzqJ9kcSeGGqpdzfM/zKx3
slsYFe3Vso3MrjF3Mwjw6XnI2zGNjxbBZC2+NPlsW3ZijsFAwm13Qef9gv7o2LLR
OOMFqKESTxtNoPhRuODHHyMql5MhiTUk1QagoCnJXgQpdg7W41IeNEn041av9wr9
oOsaZpbqYrZzD8LQ0Iwy
=sLG3
-----END PGP SIGNATURE-----

--9OLhvBqktUnNquIT--
