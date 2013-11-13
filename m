Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3KMOz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:55:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59605 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339Ab3KMOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:55:51 -0500
Date: Wed, 13 Nov 2013 14:54:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Martin Sperl <martin@sperl.org>
Message-ID: <20131113145441.GQ878@sirena.org.uk>
References: <527D1DDA.2040004@koalo.de>
 <20131108181743.GR2493@sirena.org.uk>
 <20131113050017.GO8834@intel.com>
 <20131113125111.GE878@sirena.org.uk>
 <20131113133536.GZ8834@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i13qRg9tmWEwo36p"
Content-Disposition: inline
In-Reply-To: <20131113133536.GZ8834@intel.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i13qRg9tmWEwo36p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 07:05:36PM +0530, Vinod Koul wrote:
> On Wed, Nov 13, 2013 at 12:51:11PM +0000, Mark Brown wrote:

> > I'm probably going to be looking at that at some point, though perhaps
> > Martin will get to it since he seems to be looking at this.

> Okay sounds good. This will also help in streamline the implementations..

Yes, though I think some of the stuff Martin was talking about will need
changes to the dmaengine APIs.  He was wanting to reuse DMA lists which
currently dmaengine needs to have built up each time.

--i13qRg9tmWEwo36p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg5KtAAoJELSic+t+oim9qqIP/iOXfikITADNLFePu4CDZIMB
csTTt9lhu0Q59fH03aXc2F5JdiUzuVohkH7jK8tFXuxDZ0rCqdm6Zh0FwxL/peIm
B7fKc6/qRvq3d2gaRBEcRB/aCO9GG8WoKFKdgqWlIl5yEIVmgPPyrePayXXBgf4A
RA+BiIbC5XrWzIrCWgPqkg8izNZbWvOAF7/THvp7vDleyHeFMWSCn53kczUKye8a
XVa4Nc4NV4sUWWDfy/5i5w3JcQDEa3KHR10MlRcucNWLqtc+qHY7RQ8k2azerL13
5IH69j39vNqlD8jfvmJE19nIc8fuSzGBvBX095GkAAEs/oaJoLojTB9aWjvrjeVj
2KnXOXHdq0Nhu5o8ho0IARU0/IbzEKqUhQ197H0iGB32+UQ1egyAmZQC3yzjzSJF
Yg5Namq9Wzkv7ZiQsHSmPLWZ7/DV031Es6RmE/x+eMjf07dMn6V8HUn4OnKRisDn
8nVWz9+Gph14lRHcK3CY+QFby6OpyTkSsjtoBvQWUqYSZu1JoYafCaZxGZRdyrbS
AluMKSjvFsuFEA02Yl0A7zaoXs1ApHSORpW7UQCrKATI70GXYoetAsv601D7/AFl
zvb7Zs+jCNDmuou9l49SinH/RX5j6FYP9JXOG/IPqJiO03UFrw35/IDJVQ5pMoHw
qRWrm8zlEree18mu6K1r
=gLfd
-----END PGP SIGNATURE-----

--i13qRg9tmWEwo36p--
