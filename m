Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaJPRfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:35:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaJPRfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:35:11 -0400
Date: Thu, 16 Oct 2014 12:34:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: OHCI: ohci-at91: remove unnecessary headers
Message-ID: <20141016173456.GA4357@saruman>
Reply-To: <balbi@ti.com>
References: <1413474758-18861-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <1413474758-18861-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2014 at 05:52:38PM +0200, Alexandre Belloni wrote:
> Remove unnecessary mach/* headers to be able to converge to a multiplatfo=
rm
> kernel.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Very nice

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/ohci-at91.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index e49eb4f90f5d..6181549883af 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -24,12 +24,8 @@
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> =20
> -#include <mach/hardware.h>
>  #include <asm/gpio.h>
> =20
> -#include <mach/cpu.h>
> -
> -
>  #include "ohci.h"
> =20
>  #define valid_port(index)	((index) >=3D 0 && (index) < AT91_MAX_USBH_POR=
TS)
> --=20
> 1.9.1
>=20

--=20
balbi

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQAHAAAoJEIaOsuA1yqREPjwQAKUWRZNVtuEV3Eh97B2bH49U
G5CTsKbMQtV2YhZzVb4/42Sv/Q1ANXCDSWebeK1a/L1JbIw3qox3628Fn9/RcKUO
Ebt3xX107/W0ZYJxnp7ij4UkkDWtG48K6xqKrbIQGNE8XyD9diCSRDR+4KvjooiM
sd244UqtZeTtqvaDAb1AZNBxzOxbnQKL3FglqTg7kjcBkeMPS+ga34Zj6ivxe3iK
kK/a59JBofpPF2tUJstcU6LOqlLR2buD2rfoEldGH7fClaZ1Xfbp96hvhI/I9thh
YEIrrr1t8ltSSqtrhaZxhJmPNEvG1w3XypcFOtKJBuuSZ9LfS0E9yNhTClIfnSqN
X1l311n11bZ79+PmT8uxq7eV7xhcL0aFIt3TXmlnV8HCbH3d4qYRPIB5jkDVI2d0
Gm6Gkp+e5HZZtR8Pt2mSMpdZVYkM214AnIzHNE4UHXsZw5XqCQprH2Hz2dJrZN6Z
kX4yLO/gE8b4gURk82AICO+cXj6bFrGj5FxvlpBNgjVNEunh0r7T2SdgN4IOi0Y1
EO3hGnkYfIwqpurmE9h6+xSqXzZSOP80f0fBpH4fMuOpE6VJ30kDqmu2BcBy8CM8
rRDY2CTgv8YwtKdj7RAlRLjm6YN/RxyiZMLQ908DFDeds85sY8cDvwtst3hIoOCg
TbVI6ke/n7IzNuJlp3Ui
=iEKk
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
