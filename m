Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbbA2BzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:55:20 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46319 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbbA2BzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:15 -0500
Date: Wed, 28 Jan 2015 13:23:20 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Amit Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] dts: Documentation: Add documentation for Exynos7
 SoC thermal bindings
Message-ID: <20150128172319.GG29600@developer.hsd1.ca.comcast.net>
References: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
 <CAM4voan-aoVQtRCFaB2rLLOgm+CEXg+Mc2gwfokUTu5eeQDo+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bygAmIonOAIqBxQB"
Content-Disposition: inline
In-Reply-To: <CAM4voan-aoVQtRCFaB2rLLOgm+CEXg+Mc2gwfokUTu5eeQDo+g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bygAmIonOAIqBxQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 04:21:49PM +0530, Abhilash Kesavan wrote:
> Hi Eduardo,
>=20
> On Tue, Jan 27, 2015 at 11:18 AM, Abhilash Kesavan
> <a.kesavan@samsung.com> wrote:
> > Add documentation for exynos7 thermal bindings including compatible
> > name and special clock properties.
> >
> > Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> > ---
> >  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > index 0f44932..695150a 100644
> > --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > @@ -12,6 +12,7 @@
> >                "samsung,exynos5420-tmu-ext-triminfo" for TMU channels 2=
, 3 and 4
> >                         Exynos5420 (Must pass triminfo base and triminf=
o clock)
> >                "samsung,exynos5440-tmu"
> > +              "samsung,exynos7-tmu"
> >  - interrupt-parent : The phandle for the interrupt controller
> >  - reg : Address range of the thermal registers. For soc's which has mu=
ltiple
> >         instances of TMU and some registers are shared across all TMU's=
 like
> > @@ -32,10 +33,13 @@
> >  - clocks : The main clocks for TMU device
> >         -- 1. operational clock for TMU channel
> >         -- 2. optional clock to access the shared registers of TMU chan=
nel
> > +       -- 3. optional special clock for functional operation
> >  - clock-names : Thermal system clock name
> >         -- "tmu_apbif" operational clock for current TMU channel
> >         -- "tmu_triminfo_apbif" clock to access the shared triminfo reg=
ister
> >                 for current TMU channel
> > +       -- "tmu_sclk" clock for functional operation of the current TMU
> > +               channel
> >  - vtmu-supply: This entry is optional and provides the regulator node =
supplying
> >                 voltage to TMU. If needed this entry can be placed insi=
de
> >                 board/platform specific dts file.
>=20
> Can you kindly consider applying these two patches to your next tree
> if they look OK ?

Abhilash, can you please get at least one Reviewed-by from one of the
active developers of exynos thermal driver?


>=20
> Regards,
> Abhilash
> > --
> > 1.7.9.5
> >

--bygAmIonOAIqBxQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUyRr/AAoJEMLUO4d9pOJW5PoIAIlr8iOKRp5/KjMKsvESv1vZ
pWEe4oe+9GaO59nzEEL2FVIs/20+GNEj9McZZ7XhDpOxj5T+pVcAo++9tnDOlTl9
XQtjaz6HmLQ0Am1HC6GPuCMTTRzgiQrKF98JfMvzgOkdUQDT5ChoXfd+xQMqc5jB
FRH4lF15bgg80RMkjaxQh2kjdcqcg+f05DH7R2nQWPRr/Yeo5qtAevbi+i2RJx4r
kbJJaQal9VKiUi2BL+gj2xlX0uaBjJKOOLBuYO/xCYG7i24007FtmnFHs2OEexX/
tsaISNPfZZtA/HWDeYdHke9s5WLmcFQZlH4h4Pkslqt/4PIQsOxMv8G1FUSrR3Y=
=Oafo
-----END PGP SIGNATURE-----

--bygAmIonOAIqBxQB--
