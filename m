Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaBZPVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:21:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44902 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaBZPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:21:30 -0500
Date: Wed, 26 Feb 2014 09:20:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Neil Zhang <zhangwm@marvell.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140226152001.GG30028@saruman.home>
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
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lQSB8Tqijvu1+4Ba
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
> oldest chipidea drivers, now, all i.mx SoC uses chipidea driver including
> old hardware.

Exactly, Freescale and Intel folks have shown that chipidea driver is
pretty good and ready for production.

--=20
balbi

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDgYhAAoJEIaOsuA1yqREgKQP/jS9NwhSZj9BdDTcoCyRF19h
/XqbNVv80Tq7MrI7kN7t2TzwqXpfZOqu4oP9lFu0Oof45xXCluYK/eTSKGi6iUGC
XQhv6/EfIVnnE3OaPB3fDxEVQeu+QNe2MqyBgwnjvwXuKozccujpM4aCnR7n1DsQ
aHF1RFMGpL6fsdOKT4Pg4YwXUl+GX6OVjzuCGiiCq3gZyCIBu4cdLtqtRCz8VqK4
xcZFjw4uu4Ovzp1+0X/tj3AeCQI8ruCDoq/Zes1HjiORQwi6gpYbF93uh2QL6sLh
9S6CcxGIqkPLLgNTDzi3+5n7YqeVxmi6Fa+8RlV5l9SY3An4zBLPUaiQ66Ot67CD
0fgyLlE/OrvWvwaCQ88iiUXO4ie9sHkIAy6nrG++jvNUrwNS/pxvgESh7YhmEKnO
unOSeSUKaUFj5obVsALWnZAOMecTjCS86tdhG4h3KlwYAYiIUE+cGIO1trWS4N3w
0xRWlLopMDkUci1anWNIBhrxCcSHyRqU1R3GnWQH0wm5LNnMTUQ2gG4YR4zCLRVl
8BQp8QqSvF8d3UKfUndP6uaNyF4cO3cGE5QmWB1tRIjFKT5fVuWGhj4mxshTOipG
V1f3Ucl2DTgyxtYZnBs0nJvL1GCPqhhBjWWg8vuZKTUHwZ5nBlzMN7DmYSD5VUGW
rw/vNTIvCEylqwZJiLcN
=OOpD
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
