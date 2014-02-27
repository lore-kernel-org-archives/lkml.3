Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaB0Qx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:53:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57544 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaB0Qxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:53:54 -0500
Date: Thu, 27 Feb 2014 10:52:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>, Neil Zhang <zhangwm@marvell.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140227165222.GC31254@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
 <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140226152336.GI30028@saruman.home>
 <85ec4eb2fddf48bfa281928393b0c992@BL2PR03MB226.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <85ec4eb2fddf48bfa281928393b0c992@BL2PR03MB226.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 03:30:03AM +0000, Peter Chen wrote:
> =20
> > > > > >
> > > > > > Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data
> > > > > > Stage, USB
> > > > > 2.0 spec?
> > > > >
> > > > > wait, this is a chipidea core ? Why aren't you guys using the
> > > > > chipidea driver yet ? You need to switch over to that driver dude,
> > > > > we can't have duplicated code in the tree.
> > > > >
> > > > > I'm sorry, but I won't be taking this series, please use chipidea
> > > > > driver, it should be very simple to add a glue layer for your core
> > > > > to
> > > > the chipidea driver.
> > > > >
> > > >
> > > > Yes, it use chipidea IP.
> > > > But the driver is earlier than the chipidea one and we use it for
> > > > our products.
> > > > So it may be not that easy to switch to chipidea driver due to the
> > > > stability.
> > > >
> > >
> > > Freescale i.mx SoC used fsl_udc_core.c before which was the one of the
> >=20
> > btw, when can I remove fsl_udc_core.c from the tree ?
> >=20
>=20
> Freescale has other processor group (PowerPC, etc) has used this code
> now.

Can we move those to chipidea too ? It would be real nice to remove the
duplicated driver by 3.16.

--=20
balbi

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD21GAAoJEIaOsuA1yqREBt8QAItm4IfCd2xf7vznsB/LvPC1
+95olGfVdVsuOWxQbb6HH/jk/sFwoE3N4JyK9doHSwlmS5nWwE57e+2vHjvMj5g2
4yTt17NGSvdOSUiK2J7eXJeAqEaNmNVtuj6NNIbAtMyEhmFpxcH0MdxMgxmXAyxF
+nfT/jggDQrrTOd7OQaqTVycyWb75LmWUn94kjb0mnvziQz92z5ITmbCC/ePoGZX
PHydKoo+eH4s1UbZyLc4LAm8xuF2B6m+Zhs/6cNeD6dlfFvlaYBN2iH9lpm2hjpy
y3Y+0QAXI4bdfNuCcASCk/ZdJp5D73XtSM8nxNBlOTvA2UN810bZPFgDiw5YJ+lA
WkrKSfrIQ16Sad/i5fMUkjgxk12bzHMMfiLC3dcOGlP2klEtcf6nNh3/nAhatRdz
smKMBzqGiS8EGWuXrYrLBy+jmAE1akX/ku2cUNdtLpAxMsMwwm5FWGp38Ae1vP/3
yGTywquB6gM6zYoZGLi/3D+/uCOGdwY8S2etkDLzZfuYkO+tURnYGrtDirBP/thr
gGk05Gk+mDqdn0haoU6v3o8reAzUyHy/+oHeUAq1gTJ4Z8p4Yn7XDnSWVNX1smnG
DMrzHOTUuRqvOZ5Z5inNaWEvXWI5/3ooYkW0eX0PDFccF54Hz7z/ANipfRmoez0z
GnoGe6MIvFFIYzBQCvRo
=SzvI
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
