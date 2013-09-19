Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3ISPwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:52:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34060 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3ISPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:52:45 -0400
Date: Thu, 19 Sep 2013 16:52:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130919155222.GF21013@sirena.org.uk>
References: <5237AB72.5020806@infradead.org>
 <20130917103238.GM21013@sirena.org.uk>
 <52388CC4.7040101@infradead.org>
 <20130917192355.GK21013@sirena.org.uk>
 <20130917233328.GC11390@localhost>
 <20130919140131.GB21013@sirena.org.uk>
 <20130919152626.GB7925@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fjRHIBfqI5bf54wl"
Content-Disposition: inline
In-Reply-To: <20130919152626.GB7925@localhost>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fix fatal kernel-doc error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fjRHIBfqI5bf54wl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 11:26:26PM +0800, Fengguang Wu wrote:
> On Thu, Sep 19, 2013 at 03:01:31PM +0100, Mark Brown wrote:

> > I'd expect it to be but then it seems like the issue that Randy found
> > wasn't picked up...  not sure if there's some other build that would
> > cover it or something.

> Yes.. it was missed because the script used to only grep for
> "Warning(.*)" patterns and ignored the "Error(.*)" ones. Fixed
> since last email.

Ah, great - thanks!

--fjRHIBfqI5bf54wl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOx2zAAoJELSic+t+oim9K08P/Ax1tSuR/8YvvKeFLLBEoCfZ
8Iv2+uu4OHTt6i/fn4EyfpxGlfpdMu9s3+FzT30s9NQheZoOFCuXub5PyIwNARfV
yRcYXNKbz1ZQle6bBkWn/cDDowWokBzCaU03sDIzq6gFR2XtZ112ti4Ow8iFE7eb
nRjmb30vw5r0lE72VHAB92mtUHAIqGRgiSWOVpUNQY45qe0Jy9jmiVv+bfU9Q4Vn
IwHw8l6Ln4Jm4Y7DX6iivHdtsOGhhVfA1t0gneuh9mgCxRFgMhzCcNznCprd9JEJ
ZuqD/1afDdxKE9G7fZOAwCnFKoUmFOB7p9pAQVrZZtDZVf18c03Y+he+IBNvBSIW
ssx+9qYFENSd/BoVFHkL45mJ+fRbU+jb8vsW5qv9Ii8haeRqWRLYODa9KkH15LCG
08hOyNldG8jr9vkuNTzio6che0VJeh3qbQDk/ezP8P6ZkEEB6TibkZq0re/0UlAz
p29kQSaIgHbGGozMveN9+WAntqe1Qo8UNBivmDohRWPUkDMisBRW2POXlWE3F0j/
0fWFeMBi46UidbQqlCIP0EzvJHIpG4IBZNAULyaHjMCaKOPBcTYzXHI4XBtambVu
2oRb6/WCWmHk/WggaIHAC+sODUEtd8/6uR83xgvVp50KyZZYsyIhS3Jjheagaa8U
hnaAQQfFSl6gVq2dUTTb
=DxPh
-----END PGP SIGNATURE-----

--fjRHIBfqI5bf54wl--
