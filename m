Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268Ab3DDSCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:02:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55117 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764237Ab3DDSCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:02:54 -0400
Date: Thu, 4 Apr 2013 21:02:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Thomas Winischhofer <thomas@winischhofer.net>,
        Florian Fainelli <florian@openwrt.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v3] USB: regroup all depends on USB within an if USB
 block
Message-ID: <20130404180229.GA5926@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130404171429.GF5129@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1304041339530.1324-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1304041339530.1324-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 04, 2013 at 01:42:18PM -0400, Alan Stern wrote:
> > > diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/si=
susbvga/Kconfig
> > > index 30ea7ca..0d03a52 100644
> > > --- a/drivers/usb/misc/sisusbvga/Kconfig
> > > +++ b/drivers/usb/misc/sisusbvga/Kconfig
> > > @@ -1,7 +1,7 @@
> > > =20
> > >  config USB_SISUSBVGA
> > >  	tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
> > > -	depends on USB && (USB_MUSB_HDRC || USB_EHCI_HCD)
> > > +	depends on (USB_MUSB_HDRC || USB_EHCI_HCD)
> >=20
> > is it just me or would everybody agree that depending on MUSB or EHCI
> > here is wrong ?
>=20
> That line certainly looks like it could be removed entirely.  Perhaps=20
> the original author can enlighten us.
>=20
> In any case, it's not relevant to the purpose of this patch set.

right :-)

--=20
balbi

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXcA1AAoJEIaOsuA1yqREsnoP/iBnNUZlsBWMA2z9KGTgoxcR
mofwGrRlycyCTA4KNjmT6MbvQfyD5kIs5MirDqMj9u+mHoCYUImElR9f4squM0GC
cGk2ve+836rvKJ6Vgm3sozT+wch+BTd8WpYWCTbodiiiuD55jjWsAxtJ1nx/ymZw
88aiqpKmkO8DC4AAb8icT83lAeSSIDdVNHAS/rbbSeEmg3PEODTXUw9mRv/2l7NL
KfFh/e0CRgUp4p0y3PrCowkkqu4P8k0O7daEscuBQqs8C34vl4Nky0lXKVgBR8Fp
8BzMGl++cmPTm4nVM0xeH7EvQID1pDlXw5WZhMYjsZuD7OFsbuiP/vm7H7o3gRmj
DDI3rEn3aKJaCmcu2nEVhkGOYaOaGkPSiPb+wdh+EEUFwEla16xNC455CCnZlDB9
x6lNXz+3pbeolG/6u6aNEc0Yd+JA6QxuLjl4tuQEPFMJ4u03xK5MT9M2jv5GrYc5
M0pV8fpfy/qPFxPEbmSTwejXeTVD8AI5mHB/F34JhwdUPry8u6eNAaanKI6baYix
waG2082iLawzuR6W1qt/l4y0tyGZ+hOs4NwaqSkHpz2VUaY9wTwoAwqV4Ztp0N/z
Y1knRrbIkbwJEJaqJdZwjmFCjcC7uM8czdUQTse+XRH2dCW2yVS9ic1NRmq6UN0d
HjN8fZcz76+B4aq/eTXy
=kBAJ
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
