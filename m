Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3A3NPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:15:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44084 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3A3NPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:15:39 -0500
Date: Wed, 30 Jan 2013 15:15:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: "Mohammed, Afzal" <afzal@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <robertcnelson@gmail.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Message-ID: <20130130131504.GU15258@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com>
 <510916B2.7080509@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zll6mx50Q8J7qlLQ"
Content-Disposition: inline
In-Reply-To: <510916B2.7080509@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Zll6mx50Q8J7qlLQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 30, 2013 at 02:48:50PM +0200, Roger Quadros wrote:
> On 01/30/2013 02:08 PM, Mohammed, Afzal wrote:
> > Hi Roger,
> >=20
> > On Mon, Jan 28, 2013 at 17:00:01, Quadros, Roger wrote:
> >=20
> >> NOTE: Tested on 4460ES-B1 Panda and BeagleBoard C4 only. Other boards =
are only
> >> build tested.
> >=20
> > Please try to ensure that beagle bone USB0 works with this.
> >=20
>=20
> Hi Afzal,
>=20
> I do not have beaglebone with me and don't seem to find beaglebone
> board support in mainline.

beagle bone is DT-only :-) (see arch/arm/boot/dts/am335x-bone.dts)

> I would appreciate if someone who knows more about beaglebone can help
> with verification.
>=20
> I could find that Robert C Nelson (now in cc) is maintaining out of tree
> patches for the beaglebone. Maybe he could help with verification?

Right, Afzal if you have the bone could you help Roger validating ?

--=20
balbi

--Zll6mx50Q8J7qlLQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCRzYAAoJEIaOsuA1yqREFYYQAKPfer+WYl5AjHbkXsiVdeZW
7T1cZmTOw+IZgJo98mZQmaYMInNjMoWPfJ69MDnp0cGPcTZiHpqt77V5vvyHbpAl
xjJp6AoVbQ1yfab/jNhZPm3No1LLiqXMsPbMH2BMoFNyFaj5DyBu1VNxF2tOcacE
QIpxR/SPXbDQm73i8r6YFsIRH+4EY3C7yIFXh4BGgJcM47/BIa3+olyk0erHMex+
lcU5zVK1oI8V+mL7JCxuqlLNdMMjKl9KEHOcb50hshutg6ih4iDxX6MpmdREom7b
2UZArL6+GR6K4JF2SY1aHqG0mXEyerkXdO2nESdMHiY7hDlTqHLC15tkeA0Vauwy
4cflQBxqguHvhNIC2j3dA4uGD6THj1asfNCVH5aDN/enMcMGDgc83tWJ9CwODSB/
ytb+X4113BeejJ54UHFPAtvbnyUApYzQ45smEqFYdoYoFilksQB9C2kn7z4eUhIE
YL4lxkofCcnFppeQxLSy+EcOfUoZsqGbV8bqbD7mefFUV32I0Rulb4ADs8/Pu+Dw
QFL0+Cj8fu1/Miu6Pp+MLTSKD00ea89hyZDj88OvR+69HR4wpp2FMc0PxRIL8H4m
ZG4KDFegk0ijNpQR/j5C6PWh+ue9BESPBNFZMC8IgnNpXe5Irtp3jTK6QT6f17WV
iXXd0IVU9aZamyaW4S9I
=13L/
-----END PGP SIGNATURE-----

--Zll6mx50Q8J7qlLQ--
