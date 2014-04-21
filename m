Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaDUPWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:22:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47114 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaDUPWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:22:13 -0400
Date: Mon, 21 Apr 2014 10:18:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
CC: <leoli@freescale.com>, <balbi@ti.com>, <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <kalluripunnaiahchoudary@gmail.com>, <kpc528@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [RFC PATCH 0/2] usb: Reuse fsl driver code for synopsys usb
 controller
Message-ID: <20140421151857.GH27341@saruman.home>
Reply-To: <balbi@ti.com>
References: <7aed4ee6-69e7-4f9f-9f45-675bc695089c@CO9EHSMHS031.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Content-Disposition: inline
In-Reply-To: <7aed4ee6-69e7-4f9f-9f45-675bc695089c@CO9EHSMHS031.ehs.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2014 at 09:57:03PM +0530, Punnaiah Choudary Kalluri wrote:
> Zynq soc contains a dual role usb controller and this IP is from synopsys=
=2E We
> observed that there is driver available for this controller from freescal=
e and
> decided to reuse this driver for zynq use.
>=20
> Here is the link for zynq soc TRM. Please refer chapter 15 for usb contro=
ller
> related information.
> http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-T=
RM.pdf
>=20
> The following series of patches add initial support for zynq soc in fsl g=
adget controller
> driver and fsl host controller driver.
>=20
> Based on these patches, I have the following concerns and sugesstions
>=20
> Since the freescale usb driver is for synopsys IP, Please consider rebran=
ding
> this driver name and config options to reflect that it is a sysnopsys IP.=
 So
> that other vendors who using this IP can reuse thie driver.
>=20
> Also the ehci-fsl.c is for powerpc based soc's, and zynq is ARM based, i =
have
> protected the code which is specifc to freescale with CONFIG_FSL_SOC. Ple=
ase
> suggest if there is a better way of doing this?
>=20
> Punnaiah Choudary Kalluri (2):
>   usb: gadget: fsl_udc: Add support for zynq usb device controller
>   usb: ehci-fsl: Add support for zynq usb host controller
>=20
>  drivers/usb/gadget/Kconfig        |    2 +-
>  drivers/usb/gadget/Makefile       |    1 +
>  drivers/usb/gadget/fsl_mxc_udc.c  |   21 ++++++++++++
>  drivers/usb/gadget/fsl_udc_core.c |    5 +++
>  drivers/usb/gadget/fsl_usb2_udc.h |    2 +-
>  drivers/usb/host/Kconfig          |    2 +-
>  drivers/usb/host/ehci-fsl.c       |   63 +++++++++++++++++++++++++++++++=
+++++-
>  drivers/usb/host/fsl-mph-dr-of.c  |    9 +++++
>  8 files changed, 101 insertions(+), 4 deletions(-)

as somebody else already mentioned, chipidea is the way to go.


--=20
balbi

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVTbhAAoJEIaOsuA1yqREs6cP/iu8JzXHJcyXk6gQtkt3OymZ
pa5N6Crh1p0r+6uS9L6hkrI0ipESYJMFg2GOxB1IC9YM+NIWRki7E7EHIjo/9wt6
36hATXYE+lFiuksCexk8HGpyrftRd1KqCJOj5ma5ppZf6vP2nhhx1tgASIwHFZav
rDDGw3LfEEa9m07aJayXzmQ1Fk9Yr18FkExwq7H6x4R886RU15BrpO3hWukjdTbM
yivgDbCLxlKsYZbXQlKx4f3Q89g9xjoJ7F30lo5yZwq6u17lr8vjBA4nCTHa+Em+
WT6KuhsNzVMw5Ga3SulvjNsgi1FnHlckHEzW/7fclY6jWEeG5OvZY+Ab6PaGqAOf
M9a3WY6lZJ+0GcjMs20NgEOquounvT80iaTAAceULWJ4hEnsLvXrRU8XgkAYjzl7
fX75lPfSXgjt/1GGgLPi9VMDdK35HsT7Ty1k+8rpuZGpfwm6ldqYJ0thwsgca8H+
BjgQDnDg29nW90rzrKRj0KRpDWkcPL3aQS+tak2g9sibQ1Rf4pmccgqbTzYAF6Dg
pofgzkgNA5WjuFoPexeL3i8smjLRF1itmo7DAG0EVNo9MqAWtKooNvSWRW2kbYPj
wR932yhN45d5cWasd9RUy81eO2gEDmdWEJ9RUI1GtFcxcQWzXxrYpEK3Shw69vFa
e0osVxJGFzWZNFxIXZA9
=cO9c
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
