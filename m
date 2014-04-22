Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbaDVOzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:55:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57451 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884AbaDVOzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:55:36 -0400
Date: Tue, 22 Apr 2014 09:51:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <ldewangan@nvidia.com>, <kishon@ti.com>, <gg@slimlogic.co.uk>,
        <anton@enomsg.org>, <jonghwa3.lee@samsung.com>, <rongjun.ying@csr.com>,
        <linux@roeck-us.net>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <t.figa@samsung.com>
Subject: Re: [PATCH v2 05/13] extcon: extcon-class: improve extcon client API
Message-ID: <20140422145159.GH5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
 <1397475984-28001-6-git-send-email-r.baldyga@samsung.com>
 <20140419105225.GB976@ambient.musicnaut.iki.fi>
 <53560A6F.8030909@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9iyR+p8Z2cn535Lj"
Content-Disposition: inline
In-Reply-To: <53560A6F.8030909@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9iyR+p8Z2cn535Lj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 08:21:35AM +0200, Robert Baldyga wrote:
> On 04/19/2014 12:52 PM, Aaro Koskinen wrote:
> > Hi,
> >=20
> > On Mon, Apr 14, 2014 at 01:46:16PM +0200, Robert Baldyga wrote:
> >>  	dev_info(&pdev->dev,
> >> -		 "OMAP USB OTG controller rev %d.%d (%s, id=3D%d, vbus=3D%d)\n",
> >> -		 (rev >> 4) & 0xf, rev & 0xf, config->extcon, otg_dev->id,
> >> +		 "OMAP USB OTG controller rev %d.%d (id=3D%d, vbus=3D%d)\n",
> >> +		 (rev >> 4) & 0xf, rev & 0xf, otg_dev->id,
> >>  		 otg_dev->vbus);
> >=20
> > This change is unrelated to the patch and not needed.
> >
>=20
> It's related because we no longer use config->extcon since we have
> cable-oriented API. We can keep displaying it, but this value is
> actually meaningless.

can you just add some note in the commit log ? "while at that, also
remove config->extconf from debugging print because it won't contain
valid data anymore" or something like that.

Other than that:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--9iyR+p8Z2cn535Lj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVoIPAAoJEIaOsuA1yqRE1scP/iNK13I3OOL/+5I5/UQon06C
T6ws3j9Ym6TFw4D/TM8fEjB+ALhO+W9G50CS8lkIJIomn367MzbQtYLsDXMZX7kS
MPF2YCIDPRwQ9RnoUNwfKdF46muSDJ9aaSMM0o/moizXOTlB/4sdBitVP4GFV8Xd
kylgq0EQ2fiaMA9CIWr2fgTfDSkA84FaeRcchuzePknTcP8Bq9wudK4KCod8HU03
xevQ4Zr1/Na0h2HzGYtjPrDtjx3odo88kFxnjx4ePtoDom9+0UFwWX2/1vgSDcUJ
viLxZHCBm5oqM8958yYVQGJYusBRBowLKagQ+Xr80w1LUvmhPYJf3Gt2gIpjDzPi
tpQX8KDEdtjNG5SphYkPZajUFtSSZbRoOeb+N/aPtW8sO8yBun7c3JQb1mAzHa43
DYL/1B+KgaJVyVtZsCs7AtloLRV0Vnt16b7f7AkasU/96SXRpavUApEdHqyTUt8D
JTjSYB8nUQfctl8KPFjYo5iSHg1R2XovYawcrYtUxmLaOIhFzIp5haV5QE3ijIp1
gajWzklxh57Uo/AQqDL+DgeCEc/V+mwPy8RDM3L+uUZJWi/3ng50wotnKomR2Zhv
1FZdSMz6mtXCPvRiu+biV4atHLTFw/qvswat88xsHGyrOGXNxYJ+E+35mGr0m41F
biowjxJv5Y3dYM1IVuup
=e9+3
-----END PGP SIGNATURE-----

--9iyR+p8Z2cn535Lj--
