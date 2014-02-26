Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaBZPZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:25:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32938 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaBZPZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:25:07 -0500
Date: Wed, 26 Feb 2014 09:23:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Neil Zhang <zhangwm@marvell.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140226152336.GI30028@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
 <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Content-Disposition: inline
In-Reply-To: <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2014 at 02:36:19AM +0000, Peter Chen wrote:
> =20
> > > > > easy to be found.
> > > > >
> > > >
> > > > Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data
> > > > Stage, USB
> > > 2.0 spec?
> > >
> > > wait, this is a chipidea core ? Why aren't you guys using the chipidea
> > > driver yet ? You need to switch over to that driver dude, we can't
> > > have duplicated code in the tree.
> > >
> > > I'm sorry, but I won't be taking this series, please use chipidea
> > > driver, it should be very simple to add a glue layer for your core to
> > the chipidea driver.
> > >
> >=20
> > Yes, it use chipidea IP.
> > But the driver is earlier than the chipidea one and we use it for our
> > products.
> > So it may be not that easy to switch to chipidea driver due to the
> > stability.
> >=20
>=20
> Freescale i.mx SoC used fsl_udc_core.c before which was the one of the

btw, when can I remove fsl_udc_core.c from the tree ?

--=20
balbi

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDgb4AAoJEIaOsuA1yqREizoP/2qUWFMYnGH42/TquSocBVvr
vzQ8WPXgS9bkLtAk+WGN1NwpAO7SsmoQHDHRdKpijPgL0d/HmDMJGik2yFX1joeW
fMHx9nQEsX4JYK+LNVXrOX/gKj7JUghbIVCkpRbop07NHsc8Z2zhjkYXFMEfwlwp
LWTlNHiZfTAzfBYYa64pktGGWi6isdmbS6rzaEzw7ADot+8Uz2tT3vYy2q8ry+qQ
EK414SksIS3vKS+qOw/8Mts7X+E49QZLNlesf1/C5U/0bjfDmuwhZYV5OcSXvUuh
quhmDXp4AvUmgx05vJs9niXsr2oqeGNCI71nbay74bVO7ZnT1EuYCYNUA0nbLTiR
wbamocSFTNyFIi+xdBIjZLT1vQCERA94Y0uRKvX1CAOqW+8KkttdbEcVgD53vjSp
idW+UPTpOvlhuXS7I+Uoqdzv8iDu5xC1MegdnnxcPFp7SR/48pVxsNWE1demXKPk
glbOze99AiDtePr1mrQvh/Di4ygyEVp+yM5rx5o3Y994Eo6VpG1DSc+G2Q19O64Y
VKtXap7ug2FlU8BbdA3geDAKQ2SjAhMtwvyPQYFbmFJmOU40cdgu+oMV5Wa7j+wd
Arq7ngbhwLir7tN3+I8HrOG42/V2alr8t4038LDjRxOZNQU5Y9DUzsyi4RZ6Jm4Z
uSgRrdatoZRwxYge/A2I
=su2T
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
