Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaDVSWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:22:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41632 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaDVSWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:22:21 -0400
Date: Tue, 22 Apr 2014 19:21:49 +0100
From: Mark Brown <broonie@kernel.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140422182149.GB12304@sirena.org.uk>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
 <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
 <20140418163054.GH12304@sirena.org.uk>
 <20140422115716.GP30677@intel.com>
 <20140422120948.GT12304@sirena.org.uk>
 <20140422152723.7542a3bc@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LGhQbn2N+4fvG9BK"
Content-Disposition: inline
In-Reply-To: <20140422152723.7542a3bc@alan.etchedpixels.co.uk>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI
 glue layer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LGhQbn2N+4fvG9BK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2014 at 03:27:23PM +0100, One Thousand Gnomes wrote:
> > Why is this conditional?  It's really unhelpful for writing generic code
> > handling clocks that the API isn't available as standard.  Allowing the
> > user to disable it if it's not required makes sense but not making it
> > available at all is just unhelpful.

> KConfig allows drivers to select features they need - this seems to be a
> non issue ?

No, not for the clock API - the platform has to provide a clock API
since currently platforms still have the option of providing their own
implementation.  We should fix that (just making the common clock API
available on all platforms which don't have a custom one would help a
lot) but getting anyone to take any interest has been hard.

--LGhQbn2N+4fvG9BK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVrM6AAoJELSic+t+oim9tlIP+wTQiBb23vhbQ1z/wik1Ie9v
V90ZWVPF6B21b5nITnaofbt+YhKlJbDGebDQXFpfn4Ch70pqSoYXSFQNG749yWQE
t0EoUnuaNsAoSLeUmdR6e3EiXU3U44gxXMz4dyRWo8QbAlfic1ka0Z62nbwXPRei
/+Ay9gU1QyymsgswLoIw8UAQ1gKv/5jwXqhTTFyXEez5XOaQmtVFdnVAVgSKUdEP
yc/SAUsGiNtkeReKLQECL60WN4cF1Zpqw3MSlH5Ix1ZLutZu9NGSjw33YB+04ARl
RhxovI6jWCllve+YYdGyCjHt4tNC8zYk9D5Cnf6A14MrnRMtwnoKoMEUGJAUgH8D
rgNT9gee+j/gq1mbb1Pmd/2IQyYabEU4cjg9eX6KwjqssuajjFY2eukPzmaQDUYv
f/nJ8BmkAQkP+d52eea0djJRpje+59Gt16WUNkPhHfgsc9yU4RUR/SUtlnRoUhnY
g92coY2m9a0NdXgIvk4MJHjsyN5WqC7pAtLGHd86vXoGoV5xufrPshXgsABHL/7c
wQ0cDVeAAfOwEBPIlVtlzAeYMaaezKHkjhP0XxXFQAaw6qgjYfjxc8Y+0buFXg1O
r0wfjb4i22atqaUDLCrR0gqgoTd6Kyyiuu+ubJRigjAlXgqv4/u69YW7dZOJCael
NTZ7yORBJ6A0FLwzp4Hv
=6JU5
-----END PGP SIGNATURE-----

--LGhQbn2N+4fvG9BK--
