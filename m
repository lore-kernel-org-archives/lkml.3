Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3BEJY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:24:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50884 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:24:55 -0500
Date: Tue, 5 Feb 2013 11:24:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/30] mfd: omap-usb-host: update nports in platform_data
Message-ID: <20130205092444.GP32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-8-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ga5bsqHr1s/xcZEm"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-8-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ga5bsqHr1s/xcZEm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:08PM +0200, Roger Quadros wrote:
> EHCI driver would need to know the number of ports available
> on the platform. We set the nports parameter of platform_data
> based on IP version if it was not already provided.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/mfd/omap-usb-host.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 6b5edf6..0874352 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -575,6 +575,7 @@ static int usbhs_omap_probe(struct platform_device *p=
dev)
>  			 omap->usbhs_rev, omap->nports);
>  			break;
>  		}
> +		pdata->nports =3D omap->nports;
>  	}
> =20
>  	i =3D sizeof(struct clk *) * omap->nports;
> --=20
> 1.7.4.1
>=20

--=20
balbi

--ga5bsqHr1s/xcZEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM/cAAoJEIaOsuA1yqRE6BwQAKO0VguPNIyCSbzipGPT5Z95
nOHL5qnCOQIh8m4f5ca3l7qA8DPYWyXtTu6WwrbV3UZHkZaPGT1aIYcYef8O0yKZ
av+QPgJ6QpJyBNgnPTipqIDuk+0APPJX+XLHarTpAb8FHEw89LhD6uBYIQUQhpxU
ffeUFEX+8OWRdOrEFrw4fQjBcVNDO0CGJIN3BUZ8QvwUUhZSRB1xP86/diMi9ACA
OF9fb7VjVVKwNsPEFD6Cz8D6oaXiEOoX0r4gpWwJfPBSlQl05X3+po3iZwaxNU+w
FIy3Sgrevnl0XSBwXjYu4EtPrA8/gdZ1tv9rZKJBjF7xNeyXsbC7GsAu8kmQpqdL
eIPY7ATvnOsJV0Z6aCgWnY7qXKF2HdhCATbdVB8PqhkgQfJ7LTtm8VTDhGEjoGi0
wa2al2X51wNDAZbrqv0SZKGRP5clQ1PjQyrIXZVtzIF+MTTXw3tNrFz+lX0oORjp
U3ZXqO4sv2DGQG53Yr7r32mz+mJmxRzrZb/aJqlLbsYMBr4VzObw518Yi3pcBIKO
ODjv57xIHd0UvyABTVmR70dtdurz8Wmuqr+ESbhcfHVLxUaKc9Vpw8lCrXNYAx6m
RJOmLzLdXfXqiDI3PVWNeTLvko66074OUnFk3dGDT+kBpiv0NJSmp1tRe5GHdoIi
OyGC0lr6mS1y08tZNuD9
=/CyK
-----END PGP SIGNATURE-----

--ga5bsqHr1s/xcZEm--
