Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaKDLkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:40:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37099 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKDLkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:40:08 -0500
Date: Tue, 4 Nov 2014 11:38:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, gyungoh@gmail.com, sameo@linux.intel.com,
        jg1.han@samsung.com, cooloney@gmail.com, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141104113833.GI3815@sirena.org.uk>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-2-git-send-email-jack.yoo@skyworksinc.com>
 <20141103171451.GG12011@x1>
 <1415050088.20372.72.camel@x220>
 <20141103223022.GE13359@x1>
 <1415091946.20372.136.camel@x220>
 <20141104091609.GI17577@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fze0sZZmuBV4A+b2"
Content-Disposition: inline
In-Reply-To: <20141104091609.GI17577@x1>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v6 1/8] mfd: Add support for Skyworks SKY81452
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fze0sZZmuBV4A+b2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 09:16:09AM +0000, Lee Jones wrote:
> On Tue, 04 Nov 2014, Paul Bolle wrote:

> > Nothing will break. But I think Mark prefers the dependency rename, now
> > done in 7/8, to be done as part of this patch.

> I don't agree.  The rename should be taken independantly by Mark.
> The regulator driver won't build until they match anyway, so there's
> no hard dependency.  Unless someone can give me a really good reason
> to revert it, I'm applying this driver now.

The important thing is that the dependency rename isn't silently thrown
into an unrelated patch.

--fze0sZZmuBV4A+b2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWLq5AAoJECTWi3JdVIfQ7BMH/0fsSCTGrADlqu3T1AszEMkH
a1VPtAuDRHAFZWsnAqLxFzOQOHx6Z4dMFsBMKrbYCnq+E5ExphzUlXcFTMVCbloI
UUuc16QPcob7UEy5LmHB8MVgKrhYKuSTWLPdr6WN4ypdhcsKybNpu4tZ5y5vXxe/
kxGIQoeYPcFbULUU0TbQIjp6GEmFC8kZfpIU64a5ERNXYkgyJ3Y8KRcR20YyruRQ
HKQ7Ak/vZbfg6xSEo2UOoW0sCPxEHbYufApaYsEUCUFpHl+mlJ+Z/BsvcIXrxJyq
nTvk6pSVXzlHPHluXmXuTUa4tETq3xfe+vU2QmYT9fPTfRo6jCBmmXVKEOMGZAk=
=fr+h
-----END PGP SIGNATURE-----

--fze0sZZmuBV4A+b2--
