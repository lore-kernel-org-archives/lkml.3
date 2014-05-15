Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaEOXNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:13:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45337 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaEOXNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:13:12 -0400
Date: Thu, 15 May 2014 18:12:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
Message-ID: <20140515231229.GA25523@saruman.home>
Reply-To: <balbi@ti.com>
References: <1400187345.11786.28.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1400187345.11786.28.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:55:45PM +0200, Paul Bolle wrote:
> Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
> apparently required that checks for CONFIG_USB_GADGET_OMAP would be
> replaced with checks for CONFIG_USB_OMAP. Do so now for the remaining
> checks for CONFIG_USB_GADGET_OMAP, even though these checks have
> basically been broken since v3.1.
>=20
> Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Also untested.
>=20
> It seems efficient to also include the change to phy-isp1301-omap.c in
> this patch (ie, not ship that as a separate patch).
>=20
>  arch/arm/mach-omap1/board-h2.c        | 2 +-
>  arch/arm/mach-omap1/board-h3.c        | 2 +-
>  arch/arm/mach-omap1/board-innovator.c | 2 +-
>  arch/arm/mach-omap1/board-osk.c       | 2 +-
>  drivers/usb/phy/phy-isp1301-omap.c    | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h=
2.c
> index 65d2acb31498..57092bc7f4f1 100644
> --- a/arch/arm/mach-omap1/board-h2.c
> +++ b/arch/arm/mach-omap1/board-h2.c
> @@ -346,7 +346,7 @@ static struct omap_usb_config h2_usb_config __initdat=
a =3D {
>  	/* usb1 has a Mini-AB port and external isp1301 transceiver */
>  	.otg		=3D 2,
> =20
> -#ifdef	CONFIG_USB_GADGET_OMAP
> +#ifdef	CONFIG_USB_OMAP

CONFIG_USB_OMAP is tristate, it might be better to use
IS_ENABLED(CONFIG_USB_OMAP) here. Likewise for the rest of the patch.

--=20
balbi

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdUndAAoJEIaOsuA1yqREUS0QAINQuUC/JxgSUyMI+jMAIYG/
96MHPOdCbwi5w7HIaC/UPFYnbNJNJKfsRVuhRNcdaSm7d6yOEb7FdS12gv5prt6n
QLpCrjbpSovt7K45kAlXxA3YjZnXxvfYmkXDcMHBg9wx3CFCHF2W1iWryJ/IG5Qp
2WN/awCoRWD4IueSh3SPN+sZXTX+YW5fs/sLSetFcZr3ynohJadE25do8MS6y8LR
utpAAa5Hgil3PlIGHGfWeFrnpnLZtPE8zShW5aDRxsstG1m2NHBNnmkLhvrelCYX
3NKb/efUKtRnMdmqdyqK8fOLlAwApg8r9pLdebW3+2Zgr8I5F7AyUZgiZVP3Bz80
KEOytzDvN9g6AlxvJEyinplkwLMtgHqgti8YVv8kS84lgKCvyFZ1yITeRQwSDgnk
vXYMaKIKLPlx+I6J/aFziItC4pTby9rJn7nXq+GlCMBkwTyAK09sBZ8XcUifzEI9
APIEYg3/xReSGyJtxaWnmoPMY1IrNWCH/ewg0we7Za+aEs2sWSW2cJY+v11eofeA
geFgT1Z828dH7lPX9oNRMgKvM1CD8r7+SF6JiMZbqeV35rOOg21T+fR8Eyw7Fzkx
AhNNuYiaTVl/ICQty/3lhYSGsgqBHy2ojuWUQus0sU5VgCFFRCiSSBvY+PGRkOxK
9+7Z10yZDAxaO94Bi7He
=XJqK
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
