Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3BEJlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:41:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42303 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab3BEJlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:41:17 -0500
Date: Tue, 5 Feb 2013 11:41:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 31/31] USB: ehci-omap: Select NOP USB transceiver driver
Message-ID: <20130205094107.GN32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359989205-12879-1-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1302041602350.1756-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aWauiwyUFlp3+edf"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1302041602350.1756-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aWauiwyUFlp3+edf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 04:03:10PM -0500, Alan Stern wrote:
> On Mon, 4 Feb 2013, Roger Quadros wrote:
>=20
> > In PHY mode we need to have the nop-usb-xceiv transceiver
> > driver to operate, so select it in Kconfig.
> >=20
> > CC: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > ---
> >  drivers/usb/host/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> > index 11e102e..2d2975d 100644
> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -157,6 +157,7 @@ config USB_EHCI_MXC
> >  config USB_EHCI_HCD_OMAP
> >  	tristate "EHCI support for OMAP3 and later chips"
> >  	depends on USB_EHCI_HCD && ARCH_OMAP
> > +	select NOP_USB_XCEIV
> >  	default y
> >  	---help---
> >  	  Enables support for the on-chip EHCI controller on
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--aWauiwyUFlp3+edf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENOzAAoJEIaOsuA1yqRELm4P/AocAFALqBpV1Ls94pQcJ0Oo
T/ayX4caAFOz04XqTwIfRaOocRG6916h2jUsHUZ6oBH7pWvndaKOR6KhghNxW3ci
6OFFABfFy73couRQjaZuQimNXJkwGljzi1LHPXeOFtBLbS7kGhDqIP40LKkdNvOR
ITGvQeleOIBJaMYICzLAj2r9YkZlb26jKkZeumBxhWonuezr7nfi38iCXBoNqJPL
AsD76UzBuuLRpmfjVq+c9jC7c+Zp54FtTpd06BgQL3SxiBUahYQKrD6+lWwlgbgf
GgRdjErnv/YLJNbRUu5igK7V45c2eSy1WX3iXY6JsdlAdC+QQ99u3PokvtFwahOu
rMiUpbkJILO/f32SNpknKBVLs81ypRIApWr2Gb+lTuYpr/tFfvD3v0PWK3+6vHR5
SUOgVF36R3oce9iXPfVRCRmqwo7Ug+Tf06kkDhNyEKzDqjIWs6ia2SHNu6sTx52V
kc6/Mn17OXfPq2j3RuXYoCkyM74QoYU7BoMEDRusfW4clx6vgJpJevXbSSqOqhqb
zjGGkiWycljjuzqutRJA1FYYg8e9PCbXrYpbsF7d7b2so42p6VEdzUbata4KZ19g
VdHkRZxkcdEehZeZjDXVfGhR4X/ssRs6/cEHbrfvL8PsGhPo9W20VS0xdMdzMQFd
GRajOUowgbgPJZeD1S8Y
=Pxbc
-----END PGP SIGNATURE-----

--aWauiwyUFlp3+edf--
