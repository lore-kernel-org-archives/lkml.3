Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3AQJKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:10:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3AQJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:09:58 -0500
Date: Thu, 17 Jan 2013 10:09:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: spear3xx: Fix pl080-related build failure
Message-ID: <20130117090948.GA21428@avionic-0098.adnet.avionic-design.de>
References: <1358411351-18506-1-git-send-email-thierry.reding@avionic-design.de>
 <CAOh2x=mnHtqGD17fF8TVU4uX3ceHD8dDRv_k9NwWqk=FDJg=nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <CAOh2x=mnHtqGD17fF8TVU4uX3ceHD8dDRv_k9NwWqk=FDJg=nQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:piYxbNpC3SzOmN7fuKFQbefWbziOnYiGVhjUl256vpp
 CRchtANMfk4+JQ2Jg71Y30AoNb6EoSin7IXrBypfv1SsGLTl2f
 i/XpGCFr8EtI/ro9tZCjuYAoH/husjWyK71otrXHsVBlG0jy1D
 AcmbTOy4hV6m8jgWIJpad1z97/itVt9Z5Sthx2YekHuVcX8xoU
 g2hfjc6UJSN0Ql30pcdMbIybIu3LaKPrFcqEX2DnQs/tXcwwrH
 DAMoegD8Ih36x54gYgoYSGARfP8fncRJqUKmFhxRkyfvdUUZxg
 FqneVyWtT8AbqLCo9F3Gac9mRkKvOt5DHqe5WYtmwGN+xrlZMF
 YeK9JGEgLZBWaFVUY9EqaPPHDUwY+hibtumpAsUNoZsxUpSOLm
 Hfzc6fbcci9+N2ITz8vqjHwlnue8gn3nqJBqY+xrRIFgdCjtQq
 3yMcz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 02:05:58PM +0530, Viresh Kumar wrote:
> On Thu, Jan 17, 2013 at 1:59 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > Include linux/amba/pl08x.h to pull in the various PL080_* macros.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  arch/arm/mach-spear3xx/spear3xx.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx=
/spear3xx.c
> > index f9d754f..7c218d9 100644
> > --- a/arch/arm/mach-spear3xx/spear3xx.c
> > +++ b/arch/arm/mach-spear3xx/spear3xx.c
> > @@ -14,6 +14,7 @@
> >  #define pr_fmt(fmt) "SPEAr3xx: " fmt
> >
> >  #include <linux/amba/pl022.h>
> > +#include <linux/amba/pl080.h>
> >  #include <linux/amba/pl08x.h>
> >  #include <linux/io.h>
> >  #include <plat/pl080.h>
>=20
> Hi Thierry,
>=20
> Thanks for fixing it up. Though the log doesn't match the change well.

Yes, you're right. I've sent an updated patch.

Thierry

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ97/cAAoJEN0jrNd/PrOhQicQAKvpCmR200VMKOrLnp0P8CY5
9u4qIZNKA9KNQ384kMAeKgHYttUwWpjWIT3MtUqBnDSvHClkovuuMb2MIU9AUHH/
b65A1p/wzCOHm9tYM1G0/ZCWJgtPa5UlXmINVWrBrUdbz3qlxgEMwKiMWy1BbLHC
hSCKl2fHMWpkoa+EKHuKaIVcTTNEPDavkP3tl6gpKgjTEdFJnoDb7UxX1t9FGThl
GCirrIwK4TaNQ254AAgm9hY8P7dhH6OlwQX9JqSCTgkZLHwRy5ijovugiMMlIWL2
xspp8dY0zjDYI/o2l5ZB4EqOEO65c+09pGdavvXSqDk8zk17C/QC5d/icmgORN5Y
aNjvcm76NQ7c8x9ofJ6tv4eAZleJA1H0Rmz7hNgimKxRc2Uw+fdmxHr3gYY+FtBZ
haUQ8T6xWhti7B+kvRAq1ucoP6LwDXbSL9jBbxVvv0vy6hBAtZYS3nV7iUmm8Phz
jPRSQ8g26Ja77fg3tbKPX+kToXjSzSN3E5tpWtJxwGpw2+D6oaNwNBTcthML+OGH
B7fUV1j27uV7hzvEWj9N7mbfnKj5UIfnd0lvFLgDlKQKcWcjuOjqcYuqV37jKnek
lFVbFNDMGPhLUoB7gbr2RD+Z6z2I13/kKO8vsfbRPZGMx6HV4h38mmK5zHK4aRiS
ly/uXeSvxrVNyTPDQBX9
=QI2L
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
