Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3H0TRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:17:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47748 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3H0TRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:17:01 -0400
Date: Tue, 27 Aug 2013 14:16:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usb: chipidea: USB_CHIPIDEA should depend on HAS_DMA
Message-ID: <20130827191623.GY3005@radagast>
Reply-To: <balbi@ti.com>
References: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
 <1376857245-2088-4-git-send-email-geert@linux-m68k.org>
 <20130819012400.GA2895@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D0iI3R+LB8CGxQqa"
Content-Disposition: inline
In-Reply-To: <20130819012400.GA2895@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--D0iI3R+LB8CGxQqa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 09:24:01AM +0800, Peter Chen wrote:
> On Sun, Aug 18, 2013 at 10:20:44PM +0200, Geert Uytterhoeven wrote:
> > If NO_DMA=3Dy:
> >=20
> > drivers/built-in.o: In function `dma_set_coherent_mask':
> > include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
> >=20
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  drivers/usb/chipidea/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
> > index d1bd8ef..dbd5232 100644
> > --- a/drivers/usb/chipidea/Kconfig
> > +++ b/drivers/usb/chipidea/Kconfig
> > @@ -1,6 +1,6 @@
> >  config USB_CHIPIDEA
> >  	tristate "ChipIdea Highspeed Dual Role Controller"
> > -	depends on USB || USB_GADGET
> > +	depends on (USB || USB_GADGET) && HAS_DMA
> >  	help
> >  	  Say Y here if your system has a dual role high speed USB
> >  	  controller based on ChipIdea silicon IP. Currently, only the
>=20
> I can't understand why the DMA can't be changed to fix this instead
> of changing every driver?

I'm with you. It'd be nicer to just provide empty stubs when !HAS_DMA

--=20
balbi

--D0iI3R+LB8CGxQqa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHPsHAAoJEIaOsuA1yqREhwkP/2sbXbE/GpSWvQtnxAXvc+Ek
g/RoJCKBSFteE4I05ji3sHTz0RaiZmR9vmkJBdUFN6g9rAdb+GMda8vRM9lW/xRY
NbOnnkIKQyUQ7H393f5fJwLYs8rM8JI6q0hCp5un2Wp5XO+a+FZg9AWDQE5MNJlb
e5QIPVaLengf8OdCQo23kyhDqjbwObIwnOiArLHVWhAzaOse2pUMjdWYwAVL/xLq
xNAu4L+CsMz977HaYknD7m1wCM2MYx5hmWwllwMylJPK1HRx4PVZ9Y8iYRUMjy0F
rEH0+fymLjBn3VtpUAj7Dwi1q+XQzDXMObTDvrkgBjWeAJqXRhA3PrX1LxLBWiuO
qKWuplD9q4antVbaJ45jIo+vrtS4w8rUCy0TSFaaH2GuHV/hRuro1gIKMDm4mtfO
tLODcLY1nivHxfzRw7dueMd6IRfIzHkGLG9GzcufmerwKvujNAb7D4ef9FbBLplW
jICQXY8YQEUwn2HwdpfIXl3rppgceS6RBUnx6f6EREf2hsupp34zxGiJzrxqhPmP
ul/u5ko0F/6Ma90fRBq2Nw/mNzM0rJVgcGK+v1apjyjXCb/SPrYYUq27XfyT0Axl
X0Nrz41eGkxq2Dykq7VIQ5GhSLw5rwBUTA2qmthJIvqxpqcA7b6EZdY7zS6OV2oX
euCoko1kACTZ8I2KKt7V
=LeNO
-----END PGP SIGNATURE-----

--D0iI3R+LB8CGxQqa--
