Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaG2MGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:06:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60999 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaG2MGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:06:21 -0400
Date: Tue, 29 Jul 2014 13:05:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140729120556.GS17528@sirena.org.uk>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140630142054.GA8756@leverpostej>
 <20140630151906.GG28647@lukather>
 <20140630153305.GA28740@leverpostej>
 <20140701072119.GH28647@lukather>
 <20140701124852.GB6064@leverpostej>
 <20140727184942.GL17528@sirena.org.uk>
 <20140728150911.GN3952@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5aeie0EvD5j1xj6T"
Content-Disposition: inline
In-Reply-To: <20140728150911.GN3952@lukather>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v10 2/2] dmaengine: sun6i: Add driver for the Allwinner
 A31 DMA controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5aeie0EvD5j1xj6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 05:09:11PM +0200, Maxime Ripard wrote:
> On Sun, Jul 27, 2014 at 07:49:42PM +0100, Mark Brown wrote:

> > There's supposed to be facilities appearing in the generic clock code
> > for specifying default clock tree configurations via the DT - it's quite
> > a common requirement after all.  It sounds like that should be able to
> > do the job here.  Not sure if these have gone in yet or not but there's
> > quite a bit of demand.

> As far as I'm aware, it's not been merged yet.

Well, another reason to push Mike about it then I guess - there are a
lot of these case cropping up.

--5aeie0EvD5j1xj6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT144hAAoJELSic+t+oim96f0P/isQgzzA0QD5L5Axz2SVfYRK
id62SBUcvkA8T6aYlH8HzGsaesoDsBYk9ot9lqRRoEyaN6VKE74/NHWVsGMJxL8s
hslTfoa9vALXg913r50CuOHwvvWiGKSZGHtp9FwaQwKxxiMxe9xQkDysuxTn+Z0b
1WmS4UiP1x9fce5Wkb3snh3F5wJTpePAXSiEkywGzRPrgOyn2QtqrfZ7fdTZL8rM
afuSxtYpRms8jSEh+IG3njTe5Wcp5g//1oyuJ2I7o71pbtJTGKamJ7Mt2y9tDcxd
hn3JBJa2+Up3qbTcJOaxf1ztLfQ5QcH1jB6KAKfWHa9x5INenRo3Qc19HSrvtmP4
ezzffDHls0MfTnOnPrf1ew7mo7kLn86WP5zUYPgdPrwlJ+fAeJX2BcXS1VbeE5Cz
WPy7YT0Fy6lOh4kvf4/wyN4J2lnudJBagJh1hRqO/OQx32pW6KYyO8XpGkCciyyS
wzA+wxNYWSDNdwe206gnpM4K8FX6RDoG0pWUfzGk2d3t4jVgdNjwfrPfO/ydz9f1
R3px2DrPZAFQo75LIr7ZO9BVBGqX+1crAfIX20GsNL0i/QORByfd6XiFwJ0l24wm
5Lt+wm+KTExURT+Jd2FCE80exHzTpflFu+vbB1i4/hVHpdW6U0VGMsLU5Pab/3q5
o5PSVxgrN63ujzMAgQWB
=4Xqc
-----END PGP SIGNATURE-----

--5aeie0EvD5j1xj6T--
