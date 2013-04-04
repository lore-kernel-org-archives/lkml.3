Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812Ab3DDRPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:15:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60722 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763774Ab3DDROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:14:55 -0400
Date: Thu, 4 Apr 2013 20:14:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Florian Fainelli <florian@openwrt.org>
CC: <stern@rowland.harvard.edu>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCH 1/5 v3] USB: regroup all depends on USB within an if USB
 block
Message-ID: <20130404171429.GF5129@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1365091048-16229-1-git-send-email-florian@openwrt.org>
 <1365091048-16229-2-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3oCie2+XPXTnK5a5"
Content-Disposition: inline
In-Reply-To: <1365091048-16229-2-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3oCie2+XPXTnK5a5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 04, 2013 at 05:57:24PM +0200, Florian Fainelli wrote:
> diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/sisusb=
vga/Kconfig
> index 30ea7ca..0d03a52 100644
> --- a/drivers/usb/misc/sisusbvga/Kconfig
> +++ b/drivers/usb/misc/sisusbvga/Kconfig
> @@ -1,7 +1,7 @@
> =20
>  config USB_SISUSBVGA
>  	tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
> -	depends on USB && (USB_MUSB_HDRC || USB_EHCI_HCD)
> +	depends on (USB_MUSB_HDRC || USB_EHCI_HCD)

is it just me or would everybody agree that depending on MUSB or EHCI
here is wrong ?

> diff --git a/drivers/usb/mon/Kconfig b/drivers/usb/mon/Kconfig
> index 635745f..5c6ffa2 100644
> --- a/drivers/usb/mon/Kconfig
> +++ b/drivers/usb/mon/Kconfig
> @@ -4,7 +4,6 @@
> =20
>  config USB_MON
>  	tristate "USB Monitor"
> -	depends on USB
>  	help
>  	  If you select this option, a component which captures the USB traffic
>  	  between peripheral-specific drivers and HC drivers will be built.
> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 05e5143..4636ab9 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -6,7 +6,7 @@
>  # (M)HDRC =3D (Multipoint) Highspeed Dual-Role Controller
>  config USB_MUSB_HDRC
>  	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
> -	depends on USB && USB_GADGET
> +	depends on USB_GADGET

great, except for the question above:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--3oCie2+XPXTnK5a5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXbT1AAoJEIaOsuA1yqREVesQAJB6Lfqm06VtCe6kX+gN152r
2CGOL8AOZVfE5RcVxCgQBucchGAq1Keqw4eKu5VpBExHPQJrvjaEuFqbPzmlrFMK
byvrGWFgleRqtI+dYdV+UrDoAi3fy574XaLPOcGeB4Y7Qho57EIWnnZ434Evxv0K
bhbJmRLEiBwO47CceV0Og8ljBnMogHw7KgN691BgGEO8NPHO1mGG3uFFsFnCMTeh
TG5sAt1F8pf+SmBoOwNttuVfODkw6Ye3mtWcOpNf6S+J55M40envMHZ2ERFMCypm
r1iq8dP/lKS4p0pBYaCtr8iXe/sI6gbDPhQAqPNwZ8vVYnezGCFRGY6QAOL7Kl+o
ESJ1bMqRC5FIkiVCtJUsGQzGp0zcYF2Sb9jB7ULQMU6q1gLs132SbA5M/0vjekcH
TioYt6AAH8V0YvQEAznSrfh335H+YSxtx0taomgpZMpndHOjLDDwvmLKg+OiRrDN
M7pUvi0jJs7xTjJvvMTJEyi5x+KdogS5z4ZkHgJoy/oJGKMiw2XXjkKNS2EOhxxY
dZeUnDZR8mAFMVHPiO2PH5e1/XjAD67weupv+tsKv8GLQGCt1rWI7e/u+HjVVif4
NIw9LwxyhXudTdix0SZH75226ZGPiifEl3SA83mPUXqRj5DaCDUcooCnT+HRO4bv
Pmtwcg2HLf6dYzKIglqZ
=JyVv
-----END PGP SIGNATURE-----

--3oCie2+XPXTnK5a5--
