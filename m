Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaB0TFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:05:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35547 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaB0TFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:05:48 -0500
Date: Thu, 27 Feb 2014 13:04:17 -0600
From: Felipe Balbi <balbi@ti.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Peter Chen <Peter.Chen@freescale.com>, "balbi@ti.com" <balbi@ti.com>,
        Neil Zhang <zhangwm@marvell.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140227190417.GD4862@saruman.home>
Reply-To: <balbi@ti.com>
References: <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
 <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140226152336.GI30028@saruman.home>
 <85ec4eb2fddf48bfa281928393b0c992@BL2PR03MB226.namprd03.prod.outlook.com>
 <CAOMZO5CSeN0-+U1vCHwUWzdACbLNZcyJYM63YjGJdM=-4oR-xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Content-Disposition: inline
In-Reply-To: <CAOMZO5CSeN0-+U1vCHwUWzdACbLNZcyJYM63YjGJdM=-4oR-xA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 03:05:14PM -0300, Fabio Estevam wrote:
> On Thu, Feb 27, 2014 at 12:30 AM, Peter Chen <Peter.Chen@freescale.com> w=
rote:
>=20
> >> btw, when can I remove fsl_udc_core.c from the tree ?
> >>
> >
> > Freescale has other processor group (PowerPC, etc) has used this code n=
ow.
>=20
> Not only PowerPC, but also the imx platforms that have not been
> converted to device tree yet.

hmm, but chipidea supports non-DT, right ? I would rather have pdata
added to your chipidea glue layer than maintaining the old driver in the
tree.

--=20
balbi

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD4wxAAoJEIaOsuA1yqREmX8QAIT51yHUsb2WpO+1NiyyhH5p
78r6O0ckkSbLCL/z4vJSLtmhN+wTXsk/j5Fp2CkJCIbN2kYlDKPb9S4uu4Ku1Ffp
zpaaVqUeFWVs2MApb41FGHoYOcEyVVau9rlyXyg7ot5XKB3GK0RPdeSS5nYj/R7g
X582t+eni8vQTHl6LCUwMa3Jqr+KN4Xew7hkLgljVfNruFziw5jKmEQO4FzKXQfK
Foyg7mJnNnfpIfokBoqf5Yf08Ie5KSPgtxJvon2PV/DwUwrFGcyNTa/yE99gttLo
HPxHWOJGpSKswQiuLXfB3tDXnyvQwi4VSKTuEcry2kRH/LzMq/MAppL3tXvGkX1c
d8ZrHQDK6EPtj4Mch9fs5l5VlZrmfItpjL1B8qVW1x1kMFfe/avI0AYzGR12cZex
fyfHimyQiRb721STl6lONwNcMrdns+ziRsWjjckqSc11jNKMXbgJ0AHyHqBFl7wn
qD5BsLBvBav2HTekv7YDQJjuADIdBxkuiB9LRn73adw/BvkxtXhqCOjNyZ9w6rxo
WY1kwdAcGpD7D18numpA/BtcQcG47BoIjHRj6etHrgfqnpS7UaaxZ47QuoDWqhe7
gXpLYMFmAcUg7QTGrEbifTO6hEiTOKNrjGT4m8p69HYllpvdhoIFupMXKz6Z+veA
M/pUVvvHs5S3CKQZTrO6
=U4W0
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
