Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498AbaGPOTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:19:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40325 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934448AbaGPOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:19:07 -0400
Date: Wed, 16 Jul 2014 15:18:42 +0100
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>, pramod.gurav.etc@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Josh Cartwright <joshc@codeaurora.org>
Message-ID: <20140716141842.GO17528@sirena.org.uk>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
 <53C66AEB.7030906@mm-sol.com>
 <1405512867.75389776@apps.rackspace.com>
 <53C66F3B.9020507@mm-sol.com>
 <1405515375.452411340@apps.rackspace.com>
 <20140716135345.GA508@sirena.org.uk>
 <1405519254.31919.24.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1hKfHPzOXWu1rh0v"
Content-Disposition: inline
In-Reply-To: <1405519254.31919.24.camel@iivanov-dev>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1hKfHPzOXWu1rh0v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 05:00:54PM +0300, Ivan T. Ivanov wrote:
> On Wed, 2014-07-16 at 14:53 +0100, Mark Brown wrote:

> > No, this isn't an either/or thing - the dependency is absolutely
> > mandatory if the device needs SPMI.  The defconfigs are a separate
> > thing, they just exist to give people a starting point for configuring
> > their kernel so if the device using SPMI is important for relevant
> > systems the defconfig needs to be set up to enable it but that's
> > separate to the dependency since there's no need for people to ever even
> > look at defconfigs.

> Then config REGMAP_SPMI should depend on SPMI, right?

No, REGMAP_SPMI is not something that can be enabled directly - it is
selected by its users which should be ensuring that SPMI is enabled as
it is difficult to see a use case for REGMAP_SPMI which does not do
this.

A dependency from a selected symbol will have no effect.

--1hKfHPzOXWu1rh0v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxom/AAoJELSic+t+oim97wgP/RIVJ0MRXiVtZciLvc0t1kKT
ln1AZw+HIQEbzgmHb6ZRA8y9Db+lx5qxGOgkZTZWvSVIJHCuw8YvpM7ODudV4A1T
Suvpp5s1l0R0PC9BJomhSjzxRU3u08XFyeSN03w/Z4p2XTXezKxJsvJSdaD8UVKo
1JUKoVI+F20IGxone261CzGYHTLCNIVVCSum1/dzWs9Q55XCY1jS6SF6EiwN6gVm
LSPe+Aeoy+/nkE6JhVVwvojtQRhfF272P4DJa3tlrV2COJqywCW/oAelWzwNFYQS
IKs43VWHrqb1XZB6pdzfcoChXdGsKhrhMhkvjDEVtOrY80+klZgaP49yEXb+hViL
Wsl9fzil0M0l1dGBdh5CJJfq9i1Bf4PSg+Ywyjt/UPmF1ecvjR26VFE3633rsNM/
/CCaqruEHECXQbTVAs0Kmk0vHoeFIpk6B01wNbMuh2LLcC5bYDHIX1/9T2/C0RFD
YBW4HB6a2YR02gsyXhqKCHCuvcANLDp3iFhbEgIZIhQwlnnePqKXxDyziSjaCYY+
RHLbtZR8IGflznzir8ephcfDplz8g70mzvag5cUVlUhKyzq0q+znP5jl9GDwOSTZ
UByHOTdd08vs51Gcp2QvvxDvIdNjzYxn4BqAm2yW/id6Lal6xww6fOfM7D+g01mB
I61JKDDNXUvdL3HuxvGT
=iXjh
-----END PGP SIGNATURE-----

--1hKfHPzOXWu1rh0v--
