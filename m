Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaFDVcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:32:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58619 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaFDVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:32:04 -0400
Date: Wed, 4 Jun 2014 23:32:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140604213159.GB18780@mithrandir>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <20140530112226.GA3949@e103592.cambridge.arm.com>
 <4830064.JvgTAs8Xty@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <4830064.JvgTAs8Xty@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 09:01:19PM +0200, Arnd Bergmann wrote:
> On Friday 30 May 2014 12:22:32 Dave Martin wrote:
> > > +
> > > +Examples:
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Single-master IOMMU:
> > > +--------------------
> > > +
> > > +	iommu {
> > > +		#address-cells =3D <0>;
> > > +		#size-cells =3D <0>;
> > > +	};
> > > +
> > > +	master {
> > > +		iommus =3D <&/iommu>;
> > > +	};
> > > +
> > > +Multiple-master IOMMU with fixed associations:
> > > +----------------------------------------------
> > > +
> > > +	/* multiple-master IOMMU */
> > > +	iommu {
> > > +		/*
> > > +		 * Masters are statically associated with this IOMMU and
> > > +		 * address translation is always enabled.
> > > +		 */
> > > +		#address-cells =3D <0>;
> > > +		#size-cells =3D <0>;
> >=20
> > In this example, can different translations be set up for the different
> > masters?
> >=20
> > With no cells available to contain any sort of ID, it looks like this
> > is not possible.
>=20
> Correct, this example is for an IOMMU that does not use IDs but has a
> shared address space for all devices.

Couldn't these device all still have separate address spaces?

Thierry

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTj5BPAAoJEN0jrNd/PrOhGcQP/A2I75o+TqycvUJtqqiz5AQC
bh2K9rRqbUgQoBTnAwD4oOmnM50zXpxxOd+1OAEE9Q6mRFw4FpZqGmHnkep89LtR
mh9grCRO6rqnLjt/98K2KzRdW5vtJ0PvuBHsyPW1VIhXr1vp114YkV7+bMqsrtwe
TN3W5YPZLw/vfG4VJV+lkFji3AHFgBnJgvOx12T4eiX4RoTzW4wvNzFsP+2dr50L
rythOupdjbDufTMqoWB4bmXDQBUc5FHax+jTxzAPpLAumTvWn5f3hUjfutPVPzrj
JTy3xkdIXtx+yhLf3DFzMvoWiLbS0xnu1+qJ9xp8Av6R8fCWKLyG/SkP2FAKfWCb
qc4yxogkG49yXIeLteuCFwO3SGqVMeN0b5jWPiuyBWq1avbZq1vJkfExzV+KdAxy
u0wVHxX12ab/NW+lfl2UHRdoNxJdcaVXSdrxlo6UHTptwjKiOiknf+KNQooHU3wr
LJ0dNc2Pay96PLElOkwP/Cv5iZjlp0IeZxvM4/lpYRZc4xxnl1V1gROmWTJGTUcY
m3CXyZ0hJhWBddoDODPeaY7oua2VjeEeZ8nBPkFZncvw9cezPH6EVH/+wLjxGKcG
lWWo7bT6XH4ZFjKp3tU5/J3gAnTAPHrDiOfpQWVns//jh7DHH0EdZCVvAtKpo6re
azJUtvUntUZEH6CGSCXy
=PEUa
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
