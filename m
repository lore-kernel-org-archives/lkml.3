Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717AbaGRNpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:45:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52992 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422690AbaGRNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:45:46 -0400
Date: Fri, 18 Jul 2014 08:45:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 2/9] usb: phy: am335x: group the #includes by subdirs
Message-ID: <20140718134502.GB24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:31:23AM +0200, Lothar Wa=DFmann wrote:
>=20

no commit log. Not a bug fix.

> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/phy/phy-am335x.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
> index b70e055..91c71ab 100644
> --- a/drivers/usb/phy/phy-am335x.c
> +++ b/drivers/usb/phy/phy-am335x.c
> @@ -1,13 +1,13 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/dma-mapping.h>
> -#include <linux/usb/otg.h>
> -#include <linux/usb/usb_phy_generic.h>
>  #include <linux/slab.h>
>  #include <linux/clk.h>
> -#include <linux/regulator/consumer.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/usb/otg.h>
> +#include <linux/usb/usb_phy_generic.h>
> =20
>  #include "am35x-phy-control.h"
>  #include "phy-generic.h"
> --=20
> 1.7.10.4
>=20

--=20
balbi

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySTeAAoJEIaOsuA1yqREE+UP/1PSoCGQP+lfsVv7lvuAqPTR
6JzW/t6y/GmB0Ps/dF4P2A+QYPCKEaLXPTMXe0+P7vnS43taWByG4U4Jl/B0sGHv
uFbhne7NSOqdyUwg57zwvl9uF6JIcma63ZVt2Noft92bEebU7WYz6e1eLV8SoLQy
7KsYS+EmsBsqYsWXRGh2vHDXLErJssVtYWgwk3YoUgTqDYLTTO7uqazPc/RHyA6Z
5i1Sot5MevN7Oa7KOlyFpHKq1fNjEkCtA0nEj9yRQBgWAUgnyozgKfvp9vIJQ/Am
2bJNvWB3DfW/8zO1zPcoaqgH054FaWxghMLkAgAITyik1GFwc7ks6L4fYX23J87k
9C5Do9+I+tH/E4OC7hfGKIFyAtHEtLp1bDjI5lRVgQKk7QiWt5ov1/NPSQzQjt0o
0TXWBMf54IXG+nBktF0SmSJQjFnTmds6ddG6KblVb3MVCbtJF8we0vPgwssvBkGt
dDHou4XpZ3C9GSO/mT149RvhEDKSPYaJAfjmcSN/i4oO5GRtpy/6/j7bwEGUI6PO
eCqccFzdrrj+KdW87CUw/8389LQB+gU755g+jpggtRn+5uydgQ7YqXeJs2Vh20du
XWm9/BQw7/wY9ddbMmLB1AeTPn7YOYSo81Sm1CSpGHSPzkowjQe36Qs5/mOWCwha
izj+TLX/FEuK770KGCSz
=ya9c
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
