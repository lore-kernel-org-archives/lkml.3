Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaFELhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:37:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54994 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFELhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:37:50 -0400
Date: Thu, 5 Jun 2014 12:37:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Message-ID: <20140605113710.GV2520@sirena.org.uk>
References: <1401911605-5157-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MUnXZt0Uv08c1hBe"
Content-Disposition: inline
In-Reply-To: <1401911605-5157-1-git-send-email-nm@ti.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: print error value when constraints are
 not applied
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MUnXZt0Uv08c1hBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 02:53:25PM -0500, Nishanth Menon wrote:
> With commit 064d5cd110f94ce41ca5681dcda8b77fa63d5b95
> (regulator: core: Fix the init of DT defined fixed regulators)
> We ensure that regulator must be capable of providing it's current
> voltage when constraints are used, however adding the return value in
> the print is a little more informative to explain the nature of the
> failure involved.

Applied, thanks.

--MUnXZt0Uv08c1hBe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkFZjAAoJELSic+t+oim9TWkQAJvBO0VvzG3Ib5M94Y7djAXB
sGBuOKd7m+CmWARKaCEI8uK/vmsv9sWAIIs7EqflnrGMkDot3kpDEQTed4D9jf0b
cMsXiUGhuWh0rH7nuCNWJulrTiqClIiscoXkrFhKKsGr9lw1esoa/FMTfmqVJPrR
Nvv6iHCAfqJHUzxp2RW/N8UMvd0PQkhudYmoB5LfYLnXITIli/cS3WNTuuSKKmU4
dFtQT6/q5dOlRWUEzSxiOOY9W1/7AAt/yDt/rVE6F8UW2JfjaqjDEC9A4RsfQxaD
6I1HA3AHx1VW4LtIRs/tWistZ1+sCyXulIRDI6YZT8b0sy0fFzyqglfl4Nze75qa
Br1Y2OMXAEVgR20oalscWBWTW7uirj+dSWQFrxqMRIDTBnIViFdDDhiAgNIpHN4T
SmtXXRR3kvf5F/1qXtmsVGG7/6HzwGhv4QTG30YGmBQjbYdKGh7BvEYYIbSgmTiP
nU0gR2/PvZQo+8G2o5oicX44BCmpBe+iINXOQKuKKZfAKHTVsvxwXdZDWttKZlLG
rGRIfVBSFcrXRsxXsdtNzFWnwjkb+5w0eqrfEon2sF+W0//yhTaytvBeiYU+Er9K
iBCeU2HwpLCUnmYRkLdyxra8bx5ZI6jC32O38mCupcv3gb3PHinGa4zLRhllK2mC
ILKniedmxof7Ho0BvTNj
=W8qL
-----END PGP SIGNATURE-----

--MUnXZt0Uv08c1hBe--
