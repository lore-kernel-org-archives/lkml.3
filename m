Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaBDRML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:12:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35292 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaBDRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:12:05 -0500
Date: Tue, 4 Feb 2014 17:11:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tim Kryger <tim.kryger@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140204171123.GE22609@sirena.org.uk>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
 <20140204143119.GA4627@beef>
 <20140204165906.GC22609@sirena.org.uk>
 <20140204170832.GA5196@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CQL2Jiu9fsaVZZPj"
Content-Disposition: inline
In-Reply-To: <20140204170832.GA5196@lee--X1>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] mfd: add bcm59056 pmu driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CQL2Jiu9fsaVZZPj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 05:08:32PM +0000, Lee Jones wrote:

> > What using of_match_ptr() should do is allow the compiler to figure out
> > that the table isn't used when DT is disabled and discard it without
> > ifdefs.  Not sure if that actually works yet but that's the idea.

> Right, but I'm guessing that as there is no support for platform data
> then this device(s) is going to be DT only? If that's the case perhaps
> a 'depends OF' might be in order. If that's not the case then I'm more
> than happy to leave the of_match_ptr() in.

Hey, we'll all be using ACPI soon!  :P

--CQL2Jiu9fsaVZZPj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8R84AAoJELSic+t+oim973cP/2Uc/Z3YyzkxqCeoburvzFCP
z5c6+YK4bTojchdvKgzo5NVjvlnzQE8KlFLKOsTnApPmMRc+HghsHdbOOS4lKDA0
36kdOUTb1o2vxWq2iAvaJjKASNE48N29NTo5PmgcM/Z0rwUvg12tt1fPonBzmDbL
mSV7tEyDXBN2vFa3gTNgAPISg0sAfolIhN/ZxNHj2BRA12tYTEXO8AeQ5uocw6d4
UrJ4VrFV6Wt/FiTY7lXIIsaD2SA2557g6SQOxwbOfZDLySRDUtNSI/6sYdVVQd/o
KFGwq7F2daKsEPoH3agg1gsQhZgrCMFw2G/1xVtJ7JkR+yyPoh/m2MYxG5Ewfwfi
WAiaCF/ks3IE0lO9LzIWHIltVzwUrRl04OZQL+8c1NvETw+qPbJA3PQXfoYil5WG
l5XVWLVL46eHKfsbt3FeMtNp3OFwtTlffQ0cWxv+BZr8EPLhYGM8ZKLdJoykPJil
ZISXj+y3KXDWWOKHVAL4aa/W+ULcjn1V5irw/a24W01roVDyYVrd3IZFC4polLeJ
YW9OLVZsGtx1h/RB76bXWAe7z/1Lgi27WmMruTCpZF8sWnNuaK/IXctdLm8nzwHO
7B8OsHJs4vlggEtzxqJmIeAgwIBOdN2Sg/cj9WEF7YG6i8Gz9w/MPv0HHvjFxE0O
xStEuhAGKuhsm6snSEGl
=ScuA
-----END PGP SIGNATURE-----

--CQL2Jiu9fsaVZZPj--
