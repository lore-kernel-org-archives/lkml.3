Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaHVOs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:48:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45943 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbaHVOs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:48:56 -0400
Date: Fri, 22 Aug 2014 09:48:48 -0500
From: Felipe Balbi <balbi@ti.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: usb: gadget: fusb300_udc.h: Fix typo in
 include guard
Message-ID: <20140822144848.GF22707@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140822140656.GB22707@saruman.home>
 <1408718673-2003-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline
In-Reply-To: <1408718673-2003-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 04:44:33PM +0200, Rasmus Villemoes wrote:
> Clearly this was meant to be an include guard, but a trailing
> underscore was missing. It has been this way since the file was
> introduced in 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver").
>=20

right here you need to have:

Fixes: 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver")
Cc: <stable@vger.kernel.org>

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/usb/gadget/udc/fusb300_udc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/udc/fusb300_udc.h b/drivers/usb/gadget/ud=
c/fusb300_udc.h
> index ae811d8..ad39f89 100644
> --- a/drivers/usb/gadget/udc/fusb300_udc.h
> +++ b/drivers/usb/gadget/udc/fusb300_udc.h
> @@ -12,7 +12,7 @@
> =20
> =20
>  #ifndef __FUSB300_UDC_H__
> -#define __FUSB300_UDC_H_
> +#define __FUSB300_UDC_H__
> =20
>  #include <linux/kernel.h>
> =20
> --=20
> 2.0.4
>=20

--=20
balbi

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT91hQAAoJEIaOsuA1yqREN3MQAJ6K1eCNi/bevFBT4+a29j7R
WkO+SSChIi4khe7jnPhVobm5cqGCsj7szWS4/g9Z2Ra95F+kbIsdlVjO9i5RwRvh
smzr+jDEGSkbplvNKpJbqbVlah1vCFsHwQrnyAwZoqjOImp+uKVEUXAz16QmIRwZ
xnd07BxlweB+8qbvLQteLlizeQQ1v2FmPnlGZyDi1wgZ7hVrrrF/avjBq/yseNlL
vcQerOgh2Kq1JLreeBG8CNSuCL86ZBCzXEu92BfLkZzvoskyZCbKHSYxLCH3WL8G
52NZdMF/bveBQjgUAsvz7RcQnzUezouH/WVq/hNI2sKikTzeyWAzHjlrsunG/n5j
BYtAbxF720E0ALcj7JBivPQVuumilOvjpJPiek2hnu0PfDYfIZCshDzlFC2DoXhm
1v88+gqQovve1GIewy6l2mqqLbFIyg2mPvO+JR578Zan2qErYvTChJI0/hNMAAmi
XJ3bqYdxSebAgsHt/DnziulsgBr8Uc+TgEAzShKJbgx4pPA42bcbUirZxn4KPeTE
lajOL+vwLuAMiDVxjcVegyzwYAUNPcJH8V23h0PIT2F1gI2mVKEv5bXBg7bdEHcb
4V1O2zjt0J5vcvx4zQCwDoz8R7RFbA7X6ot4G6LN4gAV2K62UuAwmZc6P9b6NTDB
5kYqS4ucb28nMHBB+hOk
=dYIZ
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
