Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073Ab3DBSTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:19:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36737 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760563Ab3DBSTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:19:51 -0400
From: <balbi@ti.com>
Date: Tue, 2 Apr 2013 21:19:31 +0300
To: Florian Fainelli <florian@openwrt.org>
CC: <stern@rowland.harvard.edu>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
Message-ID: <20130402181931.GA21830@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
 <1364922626-32407-1-git-send-email-florian@openwrt.org>
 <1364922626-32407-2-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1364922626-32407-2-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 02, 2013 at 07:10:22PM +0200, Florian Fainelli wrote:
> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 05e5143..ab5a3b9 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -6,7 +6,6 @@
>  # (M)HDRC =3D (Multipoint) Highspeed Dual-Role Controller
>  config USB_MUSB_HDRC
>  	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
> -	depends on USB && USB_GADGET

shouldn't:

depends on USB_GADGET

be left here ?

--=20
balbi

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWyEzAAoJEIaOsuA1yqREhW8P/0Z6Q5UEdng0+fjML0HZmW/3
s3G1d47uT231uto68lly1deu+VtXxPooFat3I12yC+x25ldDz9bTF86Q3LUA04N8
TzTyvKpqHuomnBxY9/HbpsLHV+Q9VBM9o14IRzr9EEhZv2b5VZ0WwVOnlKG3FWT5
+CBFyN6hAPCc133i/uR3v70P/CzgNDOwEOibObnr4l/dzoIxCaEwHO+/f6ulbGAl
httziWm8NZRtYsvYUYpZyC7Fo6dmjK6ZOPT9YVmiqFGVIIa6k9OgqmyBHPanS6Qw
oR8mJwWeWRfN78OWLvRO+pbsPjhHBZbhhzW5DMtYtlzXN88DZ0t0vKK9e1ZNBlzS
a0ePw6DBPkVR7/vsJ1ZsfgkRT/t5+v74yYgH5FLdMu85kN8RcIxnVhMwmSSvITZa
5DhWeljaNmyjqiPp8RiSiv8iLZZ8w6ErF4PYN9E3DwFHkIOr4QVwIuz2YmmAAvNA
lBpdeAHSmgInGGOM3BTGQXtGN/7/282yqeQIJqZ9jmmY9AdwqtnSx1/6GrrjzWWK
76PxkZnOEoVg8STaOhukh2igOoJ8mXsvHqszNhXnUU5OH1GDHA5brm7kuLsMwHiF
UBL+vXRQGbxYtcP3zQD3isY9Vw4lpiBEvPnuP8Cu0ciNnkj4AxmwzyJRzFwtAIGv
zORpQHOEZHkl4yB2erNW
=PlYD
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
