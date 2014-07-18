Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161108AbaGRNvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:51:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60185 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030613AbaGRNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:51:41 -0400
Date: Fri, 18 Jul 2014 08:50:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 5/9] usb: musb: print error message with dev_err()
 instead of dev_dbg()
Message-ID: <20140718135055.GE24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:31:26AM +0200, Lothar Wa=DFmann wrote:
>=20

no commit log. Not a bug fix.

> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/musb/musb_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 8623112..f867b44 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -1878,7 +1878,7 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
>  	 * Fail when the board needs a feature that's not enabled.
>  	 */
>  	if (!plat) {
> -		dev_dbg(dev, "no platform_data?\n");
> +		dev_err(dev, "no platform_data?\n");
>  		status =3D -ENODEV;
>  		goto fail0;
>  	}
> --=20
> 1.7.10.4
>=20

--=20
balbi

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySY/AAoJEIaOsuA1yqREgdUQAIIpoy6VK8hJTJDNiFSs+qfB
VQgMNYMyZLRX/ymceS+5wGTxGxaFpkhlshZVxJXBtZRpNwMCs4709cb7R9UHSlmB
7F4MNvax98vKFV9cc/J37LI6nAdGrhIVZUhiDFPQXo9CdyTiRdW+t5VE2NWmy9VT
c+Ol6I0xuPa2/vcvHBN/IS/2M9KsScyD2B5qLeIL/Y0i6lckH6DW2gPQj3EJL46Z
7a9Dlo9WL+0tqQp8nyq0Bsc116d/537+aThWFXrBM131R88UBJo0x70MnMUke0X3
8+afcWKyvCqti7iUsbc/LtjTLHdAaawwzcnLXC1MWDiag7P3LQzF6xStYJxC/7mc
h70B3OCm6iIAgEsScrO4+bKU5FcWz6X+JU5sSN4j6AO5TZx2wWn49N0cofvwM9Zr
gOEeN/KjSj6KzroQbFiI1RgHRnd09IEjD+c08faBojQfMJ3xBZAPVCsYr2eT9sSl
MEGZmj9bdryHGqDv43HXaACkRN/Kx0+jlXmeXk6cyEJM8yJebh5KKUcXCIYnXtO3
D8+/DGQlY9t/eap9jOM3jUVmtbNJoDWEkqRGWFN/FicBBsZHcK6oybRyoVgCXi37
N5FfI/fgvSnSREfibes6rW1vzFUSN04OV+bZJbQFkY69cQCWk1PUCnKySCJ/egQX
MdF5Z3/yLwcEB6r1isca
=4C12
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
