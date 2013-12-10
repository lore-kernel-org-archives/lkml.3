Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3LJQde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:33:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58274 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3LJQdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:33:33 -0500
Date: Tue, 10 Dec 2013 10:32:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 07/15] mfd: menelaus: Limit the usage of the_menelaus
Message-ID: <20131210163220.GE22750@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-7-git-send-email-balbi@ti.com>
 <20131210085701.GP12675@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <20131210085701.GP12675@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 08:57:01AM +0000, Lee Jones wrote:
> > Pass a menelaus_chip pointer as argument to most functions so we can
> > minimize the usage of the global the_menelaus pointer.
> >=20
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/mfd/menelaus.c | 265 ++++++++++++++++++++++++++---------------=
--------
> >  1 file changed, 142 insertions(+), 123 deletions(-)
>=20
> How is this different from patch 6?

have you read the patch ? patch 6 converts *only* enable/disable irq
functions.

--=20
balbi

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSp0IUAAoJEIaOsuA1yqREBVUQALEjL+bOWw6bMYQlId0ek8NI
8MrIeyeO9kr6lfv+Shxxu/E6lAF34dUNeU4sxRyy/Oi1lwsS3xZ3O9mEodbHb3V+
WUfjdB1aXpx9+gEqmzbjFL6pNq3ZMcSRdx9gfIuqMm+CAwkzJmWQIOKrZr6cjy0x
0iKJhyylv2RG/s28eosoa93JqXmbIh/zc6N+CbIHkD0x6dnn1fVoU6AHzg2hSdSP
bn9+fp4T6SwJsS3xQxzC33dQwaHUzHo1ysbnIKs7DDnzaEYhKnmDj2YltYOQqVMF
zOOZYUc15xqYYOW33H5scn5buWmfDD6fPw2saJ0dsXZHw7H2dnyZFFaX4bVScAgs
UK097PvOEXL/hH4rNgOdhGj3a4fjAwPGBK71eT/7b7VJf77Y3ZeGGYlFxM2UCt9p
xQYVcHAkYYlEcxs+iJ/dExM7sllyyHuNDbKBDqWaXQUdk0dUQ1VSZ8x27+ZIKycS
WnKoIc6QZuV+AqzbbESxe3bYUfnEHpMmcluSpzJzYVjTgfM9jBLCcps28zQ9i1Or
3jN8p71AKGbk3tbZJGGOxq5VnrX3eonfFyu+JAw9VVTvZsYFwJMDpTMNQBoAEIRk
+junAhbHjhMQDcIe+Xs8YvYeIFRmrhi5lVkyv4aCdToCKZl48grOWXy1Ba8Q7T6M
ipcbvrvtx1mK/FGlPic9
=WU/1
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
