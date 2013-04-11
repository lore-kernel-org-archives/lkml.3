Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422632Ab3DKPDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:03:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935771Ab3DKPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:02:58 -0400
Date: Thu, 11 Apr 2013 18:02:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Alexander Holler <holler@ahsoftware.de>, <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
Message-ID: <20130411150246.GR14394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5166856C.3080906@ti.com>
 <20130411100435.GB14394@arwen.pp.htv.fi>
 <516695A4.2050804@ti.com>
 <20130411105557.GE14394@arwen.pp.htv.fi>
 <5166AFD2.4070108@ti.com>
 <5166B450.1000404@ahsoftware.de>
 <5166CC30.4060507@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JT7Km6uNxtC1LbQY"
Content-Disposition: inline
In-Reply-To: <5166CC30.4060507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JT7Km6uNxtC1LbQY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 11, 2013 at 05:44:00PM +0300, Roger Quadros wrote:
> Felipe,
>=20
> On 04/11/2013 04:02 PM, Alexander Holler wrote:
> > Am 11.04.2013 14:42, schrieb Roger Quadros:
> >> On 04/11/2013 01:55 PM, Felipe Balbi wrote:
> >=20
> >>> I would avoid 'select' completely and just update omap2plus_defconfig
> >>> adding those two as modules.
>=20
> Setting USB_PHY as a module gives rise to these problems
>=20
> arch/arm/mach-omap2/built-in.o: In function `usbhs_init_phys':
> /work/linux-2.6/arch/arm/mach-omap2/usb-host.c:652: undefined reference t=
o `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap_2430sdp_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-2430sdp.c:236: undefined refere=
nce to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap3_beagle_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-omap3beagle.c:554: undefined re=
ference to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `devkit8000_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-devkit8000.c:596: undefined ref=
erence to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap_ldp_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-ldp.c:379: undefined reference =
to `usb_bind_phy'
>=20
> So USB_PHY shouldn't be tristate IMO or at least the platform registratio=
n stuff
> as the usb_bind_phy() part is used by platform code.

alright, let's send a patch to fix the check in the header. We should be
using IS_ENABLED() anyway.

--=20
balbi

--JT7Km6uNxtC1LbQY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZtCWAAoJEIaOsuA1yqREsKUP/ifFH9/Tr5YeqtnPKcYtbX6b
vtvsHdMctRROzdwWOHXLw8tz28XJ1s4ay4v75MdeMo1GRAHFQG8Pwc2Nmw09/QBr
WYHKfo3xp7gbXVkpXsS8TcbhZ1vCPxxJe0p1u8Lttpdc9wRmM+rFr1NMx9o77g1z
7/NmzTbmt9oS8Y6P8UXBbtLCfZYDFb2Sh4aYId5GM5sTxRtve2UD2hSXfD7vf6yC
o93Pv0Vf/tPS+/n5rCO8WUo7ammWYOjG4KOgnEvkmBZRgbr+PAxkJF2Vtd3KpOpB
kzi13zW4xkyYSWNDTqJerZC1Re+rk5QEJFURaeYvdG2EjShRMS604ziip0C3rphP
8PGnBxMxKXpgo45RD6cq3Qw99bGZZ3BMq00djqAc4M+2UApfrwLALZ9UZE5SfS3G
NLgGDlwb49VZQ/atJTLAHTAyyX3EiEeN9eD7aDXZNTGowv2LvzkcCG0ViYfVuc9Q
mHnlA7vOgk0F+CX35BtVlj++1l4TFqofQ/kDEQ2igpTPTBclU8zE9qBNny9eokkU
bCe+WIUyS9m4f3Sj9dtzPsroL4QJ2UxFXgavhzvtR9eVTXknEaydQbOR3yuluLnW
jVd67kR+Ln8Yqz9Iz3uaUvo2QUIwkpM0vZLo4jlFfBX0CNXBFlqfTNEdhi4EnlZo
yIaBUy07RtzHvz7bJmLy
=jeD8
-----END PGP SIGNATURE-----

--JT7Km6uNxtC1LbQY--
