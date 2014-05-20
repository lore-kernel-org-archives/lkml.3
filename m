Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaETU3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:29:32 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:63488 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaETU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:29:29 -0400
Date: Tue, 20 May 2014 16:29:23 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
Message-ID: <20140520202923.GT32082@beef>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
 <20140428115627.GY21279@lee--X1>
 <20140428140910.GB7719@beef>
 <20140520161131.GB32025@lee--X1>
 <20140520190055.GQ12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <20140520190055.GQ12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 08:00:55PM +0100, Mark Brown wrote:
> On Tue, May 20, 2014 at 05:11:31PM +0100, Lee Jones wrote:
>=20
> > > > >  drivers/mfd/bcm590xx.c       | 60 ++++++++++++++++++++++++++++++=
+++-----------
> > > > >  include/linux/mfd/bcm590xx.h |  9 ++++---
> > > > >  2 files changed, 52 insertions(+), 17 deletions(-)
>=20
> > > There's cross-deps so the regulator driver will need to go with it.
> > > Mark mentioned earlier in the thread that he wanted to merge through
> > > the regulator tree though.
>=20
> > Still nothing.
>=20
> > Mark,
> >   Can I apply this set and supply you with a pull-request?
>=20
> Can someone please send me whatever it is you want me to look at, the
> above diffstat doesn't look relevant.  Given the frequency of respins
> I'm not always paying a huge amount of attention to MFD serieses which
> look like they're going to be resent.

Just resent the v2 series.

-Matt

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTe7sjAAoJEOfTILNwq7R4t2sP/2HvJqqJkFSA13FMHxxmeLHq
MKlGOA1+OdBsNdwrd9CaCL1wjEmtl3x8IsH2uKNSDng7qgaTa8uX9jBHSdBKOVRs
YBvl5Jy8dAMYAiFGlyMBQimRL+Z7UnpfzhI1jx6k5j7faT03Fe1CHmPVeAvPnLZs
wZxRNL8Mp/Boz6spBCVTDDOa9VPFeUNwSMKmrv90m9oguGCoiFPQpJRKdGq58E1o
ekxhSxyD/FbZt3YF8hktZ7LGIeah68wt01QQLkZ5Ggz3XJEp017xoSFH1NOa3QNC
Kmj5gIhWjAXfPa9DJrmlcuWzCCT3iXE6tLvo2Puf7UKyYxzsEUg79xAfjnJG9vkV
c2K/O80leXlPGdbfS6wEG1+hV1e7sCSB4oRN4iA7yZU7hWSOO9YommmljD43zrrQ
y2sQLUtbFb+zQYTiw+4Efavfi0qhvMwFCL7gmHXzMPfIcaKDUXnbVZVznZQ1ugxU
drLEnhYIP5xe2joNA0XUGbfvGsnVGx+2zNOFmIQncx6CnGi8uMGjkgNiurk+s4GM
dqvVMLgqQusn1j3EU4eUbBVShXlOqh614MKv99hTrYXbB5gl8qho0zzt+v5Pzg8l
5ORxyT+EYifdkG4AaNwUPwoyel1shb+VG0sKZkN+HBOeOgmEaqgSyo7kqRSXzFTL
yy4RQhjci0Ij/aWbqW6v
=SgVW
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
