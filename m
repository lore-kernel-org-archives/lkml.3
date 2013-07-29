Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3G2IAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:00:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49393 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3G2IAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:00:53 -0400
Date: Mon, 29 Jul 2013 09:00:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130729080022.GU9858@sirena.org.uk>
References: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
 <20130729050011.GJ9858@sirena.org.uk>
 <20130729155609.bb9d635427d8eef1da954e3a@canb.auug.org.au>
 <20130729064028.GR9858@sirena.org.uk>
 <20130729164820.38c47ee56d98d67debc77f97@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="67hPMJEVS2CosGJp"
Content-Disposition: inline
In-Reply-To: <20130729164820.38c47ee56d98d67debc77f97@canb.auug.org.au>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the spi tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--67hPMJEVS2CosGJp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 04:48:20PM +1000, Stephen Rothwell wrote:
> On Mon, 29 Jul 2013 07:40:28 +0100 Mark Brown <broonie@kernel.org> wrote:

> > Yeah, unfortunately those issues are a good proportion of what gets
> > caught by this sort of testing that wouldn't get caught in normal
> > development so it doesn't seem worth doing something that won't at least
> > give a linking kernel.

> The problem is that you are impacting on other people's testing.  Even if
> this stuff builds for me, it may well break for people using other
> arches/configs.  These changes (adding dependencies on
> CONFIG_COMPILE_TEST for devices that are currently only built for
> particular platforms) are adding very little, but impacting on my time (at
> least).

I agree - what I'm saying here is that one of the biggest risks I'm
expecting is something that fails to link so testing that doesn't
generate at least a linked kernel isn't adequate coverage.  Just testing
that individual files build (as you were suggesting) isn't enough for me
to be happy that the testing is doing enough to stop people running into
these things.

The additional coverage is really useful for anyone working at a
subsystem level, it makes it much easier for them to do more
comprehensive build testing on their work without having to install odd
compilers or do quite so many builds.  Missing things there has been a
frequent source of problems in the past, and one that tends to be more
painful overall than these issues since it tends to take longer to be
discovered than anything found due to active build coverage testing and
found by a different kind of user.

--67hPMJEVS2CosGJp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9iETAAoJELSic+t+oim9UAYP/RDxFdiMl4kHjWnbiEguGUhZ
6dm/4YrzFsNlwVl/R1OSo0DJqSui/pJTPJvefL0JUwt2+YjBv/GX4DBVYzqMydLy
F3tY/dUeOVhmWiTvshrDpe5d0setJzANf58HqO0Da0KNbwA35k+3RVRIfxKbBQGj
nqIa0Ykz9uC1wuWBRMzJLV4W74eqEcvh3tiVxaYRImSeeAU8vkkoMh4qDddH7e3O
EjtDhQ7J6UqixuFYgQzEn8wGNafaKZEfKYeMWbRcX2NGZapJlkwJYuRTpD9e9bAe
5x2RG85mOVheGgTuXv1pTtx9G9MbJufVBl47zJiM28nFCIlGheutm0ZFrhaMKu9F
K1uKbyUG+logMnMcZ4he/zA6LP0XxnMm7Iup/EIfcC4wjjpArmXn9uCLs0mnZnFD
8h7pmJyAcyE2CPsHecfIeE46Kjp7rAv4kCGyOaOx0Gl41UB6jhBB2gFpwF9ck8Q+
8EQo2/yHu1FEqCQpfOv6N0DQOIM5dnnOY2Qsdc4ZtKmaoAyyZD5ABSZDCWXhil9B
M5dQwxfKOxxZlO0ualrsMm9qy0HYm02rz/1O6Ay5XglQcNU3L48Fl1YunG/FTtLn
9/aPmrJ/09HYCnOb80GJwSiuGU0XKpDU9+ad/b9bTa1hz4qeVb+XthdFtewGCiru
pST3fFx2foSuOVMZ/Kw+
=eAnG
-----END PGP SIGNATURE-----

--67hPMJEVS2CosGJp--
