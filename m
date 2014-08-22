Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaHVOHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:07:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44149 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbaHVOHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:07:04 -0400
Date: Fri, 22 Aug 2014 09:06:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: usb: gadget: fusb300_udc.h: Fix typo in include
 guard
Message-ID: <20140822140656.GB22707@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408712372-14686-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <1408712372-14686-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 02:59:32PM +0200, Rasmus Villemoes wrote:

you need a commit log. Has this always been there ? Which commit are you
fixing ?

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
> 1.9.2
>=20

--=20
balbi

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT906AAAoJEIaOsuA1yqREoZcQAIkU/ptl5LiXohGbYxTGvYdk
HgE33mkCR/l7iP//eifb96AV9wFGS1E2sKg3wf1pLDtoZNsR4E1hv4+ZzmgXKVXJ
CSO9VKXm03sPkZGVhqskcZQ8yj0opRg9baEFiRWQlv/Owdcl9YYbyx/KI4L2V8OQ
bKyHVdSAoj3zt5PposraEqlAopHo+mzaXRATaLo7Q7vfNAh9PcCDEM2gkNaRWghq
ikNXWVev6GDNGgWIrhm7SdbLrdHptGYLtWFrdnNw2G3fEW1HihcL5IR4o35ZbYMN
LfMxs2XI5uM7laa1ksXdEINZ7RM8XeS2MT9mrXIIznhVNt6tNOB79vsMoqiw/7UA
1hlTRrP1pr4qE1LBncw90EUheArL28dX5xAFePI0uwajXLV1euKDA/9vOwdqBKHO
48P0421yTsKLQUvGPoPgT5LO/gpKujgJDjCLGZ04KTvlr3JLrWacXyhuVncdvC54
PUll0CprjJKkzdswD7qwxbJirJohkg+8UxBB9oWQifBwVdRX3Ho1SE7YHa3P6jLJ
TeR04KcDySs9vGlW9c2Wt9cFDwQLxuTVeZxT+BZCtmLngL1r19eB+bgSV5ACEIUE
mJvqMlwVHx1gUaoXYbPvb3HbQ4RXns+bIkdW4sUcLYtvVUFkgmN/h8Rk9RYijBrj
U9ZLZrsJo7KBZuBsypJz
=J6FF
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
