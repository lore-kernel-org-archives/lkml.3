Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaCDG6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:58:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36990 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaCDG6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:58:51 -0500
Message-ID: <53157997.8000408@ti.com>
Date: Tue, 4 Mar 2014 08:58:31 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20140304143543.4ab2321f14a61d84bb63b692@canb.auug.org.au>
In-Reply-To: <20140304143543.4ab2321f14a61d84bb63b692@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="7hrLlREP00dkQSMVoC6A4FWrt1r2UxaEn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7hrLlREP00dkQSMVoC6A4FWrt1r2UxaEn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/14 05:35, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> After merging the omap_dss2 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> In file included from drivers/staging/xgifb/XGIfb.h:3:0,
>                  from drivers/staging/xgifb/vb_init.c:4:
> drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vga=
types.h: No such file or directory
>  #include "../../video/sis/vgatypes.h"
>                                       ^
> In file included from drivers/staging/xgifb/XGIfb.h:3:0,
>                  from drivers/staging/xgifb/vb_setmode.c:2:
> drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vga=
types.h: No such file or directory
>  #include "../../video/sis/vgatypes.h"
>                                       ^
> In file included from drivers/staging/xgifb/vb_util.c:1:0:
> drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vga=
types.h: No such file or directory
>  #include "../../video/sis/vgatypes.h"
>                                       ^
> In file included from drivers/staging/xgifb/XGIfb.h:3:0,
>                  from drivers/staging/xgifb/XGI_main.h:4,
>                  from drivers/staging/xgifb/XGI_main_26.c:16:
> drivers/staging/xgifb/vgatypes.h:5:38: fatal error: ../../video/sis/vga=
types.h: No such file or directory
>  #include "../../video/sis/vgatypes.h"
>                                       ^
>=20
> Caused by commit 08667731d1d4 ("video: move fbdev to
> drivers/video/fbdev").
>=20
> I have applied this merge fix patch (you should add it to your tree):

Thanks. I forgot we may have fbdev drivers in staging... This is now
fixed in my for-next branch (along with a couple of others, found by the
kbuild bot).

 Tomi



--7hrLlREP00dkQSMVoC6A4FWrt1r2UxaEn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFXmXAAoJEPo9qoy8lh71TQgQAKrasPWYSsBGqp/wxmja4YTC
109IWtOliTL+LHIxJ9kOJXC7EfOhvtdAQb3Q7OmYpfRcdXWKaciXzeuFtNoS+qrf
mT9uQkDxQ6k9UIsrYNwm8OcLi+W1ZSsB0TPkxRBtr03657o0m9QLF9KqOg/dOYUB
u1S2pR4hPmLto/Yp3l5DXbtsDe3wrECY3e5lvrlnQjZEQGvyTNq4oT1J/DdzscxC
5S5YX8vAexsX3JjE9ynWBLt5ks9FyI9wR9r1k67PpxcAveb/R5RZnPFwU1sYwx/J
dzTO4gwL7qngqnvpw/kzDHfIeGM87YuSERjfdTaE75uW+q451tvJ5m5T6bVXZyOz
i52x8pOxv88hSXzvc47hnfQK61RwqyLedHgsezWDvoFizSyCdEzeVtCPL6k/5jgN
qFW0wG8Ien5xpEq/IXCopQysjBhX7/NejFAoWizvhUHuLW8pfzuHWra8ezOz1xeG
9T2gWEJXl8t75Kl6f5ayKlCYD1roxMxWLwAgc9cJUZM4BuTKQ38aulDPsePZ2wVU
OgzAjTVXaSrnLocCyWBv/Jnvx41iMlnRgn3cTXRopLqjYMGS7m7Xp0Qrwz7MwJNN
bkA7Q2pBa2qDXkPQBL9imz2C4lUx62bYtrNK3XHHpvLwQFamhC5Ca5ueMGCswV5M
H4hk5VTDClc41tv6lXUv
=kSJy
-----END PGP SIGNATURE-----

--7hrLlREP00dkQSMVoC6A4FWrt1r2UxaEn--
