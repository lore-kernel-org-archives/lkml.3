Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3GDKVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:21:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53476 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3GDKU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:20:59 -0400
Date: Thu, 4 Jul 2013 11:20:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        patches@linaro.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130704102056.GQ27646@sirena.org.uk>
References: <1372919930-513-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6gn/eZb/68GftVhn"
Content-Disposition: inline
In-Reply-To: <1372919930-513-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] MAINTAINERS: Upgate git repo for voltage & current
 regulator f/w entry
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6gn/eZb/68GftVhn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2013 at 12:08:50PM +0530, Sachin Kamat wrote:
> The current git repository hasn't been updated since quite a long time.
> Update it with Mark's git repo which is the currently maintained one.

Applied with a redone commit message due to all the typos.

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>

It's better not to include things like the CCs in the body of
submissions since they end up as noise when applied.  This is
particularly important when sending a lot of small cleanup patches as
effort to apply things is more important here.

--6gn/eZb/68GftVhn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1UyFAAoJELSic+t+oim9koQP/j+OwUwj9Eb+i0jQCLYoSdsV
B88yBUIJiwJ73cK7lknnI8/zR6pvNVMGLe3H/Lqt92xDz+rJwAOx2nry70SRTqA3
B8XlkAwotJQEtmn1xe8h2I1b2H4lBhtpNZ8WdckuJl29GMsRcqwigFG/TfpbpSG/
dTI51j1yoMZ3lhJ6NfQpE9hjleyboGXreKPj/umrEz0um8bQYzmlllH11Is4sarp
MPSRAtNw66INrOOvL5uuqRLb8jRo+8AA3CZh1woox2isXpvjbNjX8K03FYB1b2u/
SDSP1gqR/zB5qAGSUxqiv8+HZ2wT18osZvGISwM/cnDMg2rgIVFDIuHs2xLothU9
L/gs/EXcAs2Qx4h5wdlpfb3Jt2PVokm91qmFaV/da7LtGief1wqsaCB1COU0SG9Q
dtSzufyXEcihTXMCJ005/wUkrlXZopzGgd79IJ05DsZzqnJMmiLbp8GKD5HXaLvr
M44EGSoSYDVRx78NGnXK3RRUMeYhPrcw/Pw+pOUPv+hR/LLIXj/QHxaopCcoRMld
dVBLzPCheuaw0eQ20CV8D3MOEPT3vwiDvaSQrl30RVelIC0u21u2VB7vxYm24ir7
iUxmCecEcFVX6SlL7/Jr3NjWHIjNp44hm8lt7bUKS8Kw6gPHjes0+KAc28LH7jJo
C/XDAKd3znU40q+Lkt+g
=8D+V
-----END PGP SIGNATURE-----

--6gn/eZb/68GftVhn--
