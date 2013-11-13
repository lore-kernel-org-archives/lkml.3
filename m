Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab3KMP0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:26:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:3659 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3KMP0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:26:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="asc'?scan'208";a="434647334"
Date: Wed, 13 Nov 2013 20:01:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Martin Sperl <martin@sperl.org>
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
Message-ID: <20131113143101.GD8834@intel.com>
References: <527D1DDA.2040004@koalo.de>
 <20131108181743.GR2493@sirena.org.uk>
 <20131113050017.GO8834@intel.com>
 <20131113125111.GE878@sirena.org.uk>
 <20131113133536.GZ8834@intel.com>
 <20131113145441.GQ878@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <20131113145441.GQ878@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2013 at 02:54:41PM +0000, Mark Brown wrote:
> On Wed, Nov 13, 2013 at 07:05:36PM +0530, Vinod Koul wrote:
> > On Wed, Nov 13, 2013 at 12:51:11PM +0000, Mark Brown wrote:
>=20
> > > I'm probably going to be looking at that at some point, though perhaps
> > > Martin will get to it since he seems to be looking at this.
>=20
> > Okay sounds good. This will also help in streamline the implementations=
=2E.
>=20
> Yes, though I think some of the stuff Martin was talking about will need
> changes to the dmaengine APIs.  He was wanting to reuse DMA lists which
> currently dmaengine needs to have built up each time.
Can you elobrate a bit more on what you guys want to do here?

--
~Vinod

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSg40kAAoJEHwUBw8lI4NH/LcQAKJW7QeAHamIiq7jqWWlBkXl
NIOetfjVqPJwMRjH2vcLm62EFARE9x4Q/V88Suz+vd+j6iIcB+jgQK3MpGU2Xl4U
lg+tl6XUyA0aA6AVKOApyQQhm6jpkGDrZNX5tSYXpMYKa0/fkKozmtrCSXDilmle
fezBaRO7WJ8rZyEV/N57pxb/724bKPfkdBIslNM2lCnkm7DJWjnI2HjtetXpXETY
DEIfsSADBWu/jizmK1BWa+Tknx/vUV5vnCzESSavFEkEGHhLjBUYNlaBltgAzE3F
1S0RrlUM5nqdEN0cf2Cl0Xjn4CFX5RrATTg/+XlnH/Q+OdmJ6/h89VLRR+BKDv7B
SwYaaBfFbBfvcDkvfl42Bwy4gHEpjW4PRbv1WuG5kjGLXkN0TVEnzsuLenuCSTz3
Ba/V0pu1EueDf4BmgbjZ5Fsg1JpwNha5Ri8Ez5kKaFG699GWCADr0ZLWmn1hwh1n
OM2WxbtQqbY747qUqdiGv0/63kgix/4C9IeOPRyoDoxeNuGIpRcerI1r7EaTIHuT
TNc8PXrCi4rDzvA0KhciIBVabEafCMJkxNQ6mXuG7DMm369xq3SeNozcN8zKaTol
p+/LVRzgcOcnX8C0E18mlcamP0Vhi7FcHINyvKrk/hCSX2MwyRLkxpoXE/Ojx86l
yZpJCrd1qxloExr7idgJ
=/PA/
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
