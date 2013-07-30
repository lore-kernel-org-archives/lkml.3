Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3G3NSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:18:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982Ab3G3NSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:18:30 -0400
Date: Tue, 30 Jul 2013 15:18:28 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "albert.u.boot@aribaud.net" <albert.u.boot@aribaud.net>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 05/10] ARM: sunxi: Add Allwinner A31 DTSI
Message-ID: <20130730131828.GB12562@lukather>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-6-git-send-email-maxime.ripard@free-electrons.com>
 <51F78056.6000104@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <51F78056.6000104@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Jul 30, 2013 at 09:59:02AM +0100, Marc Zyngier wrote:
> Hi Maxime,
>=20
> On 23/07/13 23:25, Maxime Ripard wrote:
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/Makefile       |   3 +-
> >  arch/arm/boot/dts/sun6i-a31.dtsi | 155 +++++++++++++++++++++++++++++++=
++++++++
> >  2 files changed, 157 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/boot/dts/sun6i-a31.dtsi
> >=20
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index 641b3c9..1482533 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -210,7 +210,8 @@ dtb-$(CONFIG_ARCH_SUNXI) +=3D \
> >  	sun4i-a10-mini-xplus.dtb \
> >  	sun4i-a10-hackberry.dtb \
> >  	sun5i-a10s-olinuxino-micro.dtb \
> > -	sun5i-a13-olinuxino.dtb
> > +	sun5i-a13-olinuxino.dtb \
> > +	sun6i-a31-colombus.dtb
> >  dtb-$(CONFIG_ARCH_TEGRA) +=3D tegra20-harmony.dtb \
> >  	tegra20-iris-512.dtb \
> >  	tegra20-medcom-wide.dtb \
> > diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i=
-a31.dtsi
> > new file mode 100644
> > index 0000000..c6c19a9
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> > @@ -0,0 +1,155 @@
> > +/*
> > + * Copyright 2013 Maxime Ripard
> > + *
> > + * Maxime Ripard <maxime.ripard@free-electrons.com>
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +
> > +/include/ "skeleton.dtsi"
> > +
>=20
> [...]
>=20
> > +		gic: interrupt-controller@01c81000 {
> > +			compatible =3D "arm,cortex-a7-gic";
> > +			reg =3D <0x01c81000 0x1000>, <0x01c82000 0x100>;
>=20
> Th Cortex A7 TRM indicates that its GIC has the virtualization
> extensions. You should reflect this in the binding (wider GICC range,
> GICH and GICV ranges, maintenance interrupt).
>=20
> See
> http://infocenter.arm.com/help/index.jsp?topic=3D/com.arm.doc.ddi0464d/BG=
BJFJJA.html
> for details.

Thanks!

I'll add those to the v2.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR970kAAoJEBx+YmzsjxAgsSEQALbW4SmtNkFiy5CeWMEUk64X
4UGNL1NPpE5miAXjhBQYqJLzRKaXA3NyIRJ31zX3+WXruFjmNSIIdPCfMDEEaubt
BTsLFmHQFY0ag4tmLSXEDWNfaBS6afS158OMw0duRwD/b3SLiDikTCSkWMzLkPbA
NQiA+5Gh07fN0/q3qb0g3I8YyHzaMCKiUILQcUDDoTQXN/9LGBEOaSqgDvAis/lG
mEfJCOQv5TfWVN3v4js13VDImx87DJ7gQIPs+ZJTTI557PRDSGYxhMbZq3rak+Iw
AdSCJxqmr20k/To2vyeFC3J95EZkDpHpPYVFBTtrkMTM9F1XsHTka4m5mFH5iEir
PjEIyoMvb8yKFzR9p5vHDa63XWsv99cteXMUClHl3FxCTtiIagHUA75OuFxm80ov
Tv2YwgXo+IwJ3hDYqPImFd6QM39DPl8dajpRWxbeR5OncvVJ/CqhyxZpiy1rqsPA
cLsNXnPbLHbDvp0QJh+lGVdEO+EOK1kl9H5aCcVkhOF0a7E0NVxXjharAUBDp/qd
WRD9FJpPl6m2tz9VHYCgc8lH3jvEe4i3jF2BZw/E3oGqkMyDedTuee2TGpqy2L1e
GwsTsMyEOjJmMhCzX+zd/5uAekTWK6vsLOjoTW8RP22rkODKH0NHZCIrk83U/y8W
CmBAtZOk4E8kTLz4FJyF
=BaPy
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
