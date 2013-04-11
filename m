Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3DKK4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:56:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56642 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3DKK4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:56:06 -0400
Date: Thu, 11 Apr 2013 13:55:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
Message-ID: <20130411105557.GE14394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5166856C.3080906@ti.com>
 <20130411100435.GB14394@arwen.pp.htv.fi>
 <516695A4.2050804@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Content-Disposition: inline
In-Reply-To: <516695A4.2050804@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 11, 2013 at 01:51:16PM +0300, Roger Quadros wrote:
> On 04/11/2013 01:04 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Apr 11, 2013 at 12:42:04PM +0300, Roger Quadros wrote:
> >> Hi Greg,
> >>
> >> The following patch gets rid of Kbuild warnings when USB_EHCI_HCD_OMAP
> >> is enabled.
> >>
> >> Patch is based on your usb-next branch and is needed for 3.10.
> >>
> >> From: Roger Quadros <rogerq@ti.com>
> >> Date: Thu, 11 Apr 2013 12:08:19 +0300
> >> Subject: [PATCH] USB: ehci-omap: Select USB_PHY
> >>
> >> As we need NOP_USB_XCEIV which depends on USB_PHY
> >> we need to select USB_PHY as well.
> >>
> >> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
> >> is enabled.
> >>
> >> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet dir=
ect dependencies (USB_SUPPORT && USB_PHY)
> >> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet dir=
ect dependencies (USB_SUPPORT && USB_PHY)
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >=20
> > Ideally, however, we wouldn't select any PHY in particular as different
> > boards might need a different PHY driver, even on OMAP ;-)
> >=20
> Right, but we need to select USB_PHY here as the driver uses
> the USB_PHY APIs.
>=20
> The NOP_USB_XCEIV selection could be done by the board config.

I would avoid 'select' completely and just update omap2plus_defconfig
adding those two as modules.

cheers

--=20
balbi

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZpa9AAoJEIaOsuA1yqREjowP/27PkqAeStaDh7m+HMQ8Y0ln
1hqzHgluteu7b6SPbg7JgA/UmlL8wVZX8zoU3OV9fYhiGEIuImOysKMdB8Vk0n1l
F8K0SV2QxaLoePPH05oGBtGnR5savcakKKAj5NFgJdzFJM4rCySveEJB7t6b6L0u
8VFx3dof4faBmA7rgOX/nPKbVdd+64HxGRGvUgINe5GnyBP+TbqphE8FyQBlCJQN
+N7C48mRDwKCBYbryEVFB0tILonPbmgGmYrdzAzE8ogz0guuhdQDMQhuyKcIBElU
jAiAVxe4LkvD+Yh4iJXDJxxAP98ZaP2uatecJ405/XtQnuDdZuTof6ZrINa4ZGep
vJLdy54V4oFJ6HD1npHFFn/0kGzNXcxZxa3yFaB1mxkEUpShafkL/CA//LOtsdw7
8/C+cX7rwYTXPkBIKzKFt1el+le9gPq+s4xXCXzOak8kKr30/s8B5NOLwH+61F1x
krBv08cVWAciMz/DquWmleTYeECTwn1HPeZ+TlLH+rZa5p/NsA+6k6mSl+WHK1HV
qJLMKTygnKLn2GlNso6TcYr+8x3XSyfrYdMGpVTr4JeSlCM2xH81WXCAV9tfYucD
QVUfqN07fpbfaIlmKs0Jc9vpoDtdqdCGMnUPYZbIf7hC3ikkeDjfl6iHNJ3tYJuq
v0g9jJ4UngqysPBCVLcT
=yiF6
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
