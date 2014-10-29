Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaJ2A3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:29:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39836 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaJ2A3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:29:37 -0400
Date: Tue, 28 Oct 2014 19:29:08 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget-fixes
 tree
Message-ID: <20141029002908.GA29769@saruman>
Reply-To: <balbi@ti.com>
References: <20141029095848.12be411e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20141029095848.12be411e@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 09:58:48AM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> After merging the usb-gadget-fixes tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
>=20
> drivers/usb/dwc2/gadget.c: In function 's3c_hsotg_suspend':
> drivers/usb/dwc2/gadget.c:3633:2: error: implicit declaration of function=
 's3c_hsotg_core_disconnect' [-Werror=3Dimplicit-function-declaration]
>   s3c_hsotg_core_disconnect(hsotg);
>   ^
>=20
> Caused by commit 9f2104db1295 ("usb: dwc2: gadget: fix calls to phy
> control functions in suspend/resume code").
>=20
> I have used the usb-gadget-fixes tree from next-20141028 for today.

I dropped that commit for now. I guess I forgot to build test that one,
sorry.

--=20
balbi

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUDTUAAoJEIaOsuA1yqREdtUQAJPLY8TmkgKM31y/Vk9lK5VB
QrGJ9ZtNcUWyLe6iGCvXWC+tisJS+EsYpYXrJ0v4YZHrP3k4RqLheJOpSB4L7p6v
3yLMbP0nDowWwkcxYJDu+pgG+OxKogEVq4wIT3YC6AFemUojAvhKxKbCCahRtV5H
Tn1vsOsTtyA4wCcx812jlZq04Lb+HM7Zy5/gfNop9PY7Z0AXdRhZkI2Cm20TzogL
pHlHrhHIPnSjCuEfB//c9sqUa8Q20bSSZaNd+9r5sW86XJkmvDtGRCUIKyXDE3rl
oirTrJwBZg/rFepNp8vWmmgimwn0ntfbzrutOn2T2UlMBu0NWXRORbzd70eONa9E
iWBCtm72lbFJjhuxLgBouERm3R8La+mQVts8LqkUHP+k6E9UZlBZf0/x6ChwDUiK
d2QyZ0XTdlNrr80f2kJvBgZ88Qk3ynJra6R5IJJAXaUm4aXj6Lvm4kuU6iRbEQVg
f4rFC+0P1+JlswRaBOiiyMYUuhr+MpjRNxwmlDFU7KMFG+iDplMU6UwVSpAwt7zx
vACHM64h7OakGcF5aOwjIY7CqjvterhJtqma2XJml5e5qMtYNdupjffZb9Bbo8Ap
GDWLyTVfVyjRdfT7a0XO38DwajVQZIld3dGyGFCe+2O1g8+gw94t/wwgQ9Y3CjMK
kdoDpuebBGn/mft6DsWz
=8wpv
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
