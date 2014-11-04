Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaKDA5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:57:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36368 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaKDA5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:57:10 -0500
Date: Tue, 4 Nov 2014 00:55:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: gyungoh@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        jg1.han@samsung.com, cooloney@gmail.com, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141104005542.GB3815@sirena.org.uk>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141031164418.GC18557@sirena.org.uk>
 <1415051139.20372.85.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j6zkAHxOZJkiczrA"
Content-Disposition: inline
In-Reply-To: <1415051139.20372.85.camel@x220>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j6zkAHxOZJkiczrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 10:45:39PM +0100, Paul Bolle wrote:
> On Fri, 2014-10-31 at 16:44 +0000, Mark Brown wrote:

> > it doesn't seem obviously related to the driver
> > change and should probably be in the same patch as the MFD symbol rename
> > for bisetion.

> I don't think there will be bisection problems (in mainline). Currently
> this driver depends on SKY81452. But that symbol doesn't exist. Only
> after both 1/8 and this patch will this driver become buildable, for the
> first time. So it's not that this driver was buildable, became
> unbuildable in 1/8 and buildable again in this patch.

> (I don't think it's much of a problem that the regulator driver got
> merged, in v3.18-rc1, before the mfd driver on which it depends.
> Avoiding that temporarily problem appears to be more trouble than it's
> worth.)

The symbol rename should not be randomly shoved in with another patch,
and if the MFD still hasn't been merged then it probably makes sense to
do the rename as part of merging the MFD so it's clear what's going on.

--j6zkAHxOZJkiczrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWCQNAAoJECTWi3JdVIfQEVgH/3b8xvvY7XaXswI0SnFRS34n
NjAkr4i/yNthEQvI+lzXpW4NQfAmgtzDkChLVM2wLaKl4JzwrKyLpEr+OXQsUAsl
qK+ZkUDF4tL33isb96E9P755Np8idMmQvIZxRRez/fLQ2+XZ3Qt/tZhdFmgQc5vF
mxjRWQuk4D4Lt3Zn1q3+TJBWd9kuwf19is6cMl12MMWwEf+J1Vea7S6BIN7iw68E
/TGqIKL6cg0YB2HQgI7uq2zOS1zdG7NcUGmbFCyZUwKwelTSZ+tsxvHUGRKJfXvl
HG7VD3vV8wiwoxNRDNZV6ymbWkq5+LaAN8/hzVEqOzk9U8t1XXWdMxCBa5ezaIo=
=5uCL
-----END PGP SIGNATURE-----

--j6zkAHxOZJkiczrA--
