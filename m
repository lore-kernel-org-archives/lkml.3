Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaKZQjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:39:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39514 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:39:18 -0500
Date: Wed, 26 Nov 2014 16:37:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141126163702.GI7712@sirena.org.uk>
References: <1416898986-24530-1-git-send-email-jack.yoo@skyworksinc.com>
 <1416898986-24530-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141125121916.GW7712@sirena.org.uk>
 <20141126014007.GA2876@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gPUs6siww+AY7XMI"
Content-Disposition: inline
In-Reply-To: <20141126014007.GA2876@jack-ThinkPad-T520>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 7/8] regulator: sky81452: Modify Device Tree structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gPUs6siww+AY7XMI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 26, 2014 at 10:40:07AM +0900, Gyungoh Yoo wrote:
> On Tue, Nov 25, 2014 at 12:19:16PM +0000, Mark Brown wrote:
> > On Tue, Nov 25, 2014 at 04:03:05PM +0900, gyungoh@gmail.com wrote:
> > > From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

> > This doesn't apply, please check and resend.

> Could you please explain why this doesn't?

When I tried to apply it to my topic/sky81452 branch git am barfed on
it, presumably because the code you based it on is different to that
branch.

--gPUs6siww+AY7XMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdgGtAAoJECTWi3JdVIfQ0AIH/1KywIS5SmzYpSqMNV/Saco7
9PP38VjEPiEN7YvRCn9HliuZ932X6x3SXPjObzLtlx4D3nVD+llYqEVHl6dKMgV4
vRAFjRt6fkd2MVm+FRvKH2C/1hiBemXVYruUCLeaql8orN0D0ziAmuhSVgaMUXrp
hSJBnEODoNSdetacOU3eG6ykIjyFA+dqygSc1CZKyN55n4hbZLI1fku5GvbdqaVP
e1ytWy3EzLFazIMxuitAaXSejGDLdnKCT0B75ho0i0saqweFsQBsI6uWPd/tlbLU
UeSym4pLvm8tK6VvzDp1WMBQdmmzXJWfKKcsrE5vbim8ujdGVukLQ1V2bYnMEmI=
=hNu3
-----END PGP SIGNATURE-----

--gPUs6siww+AY7XMI--
