Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3GXMgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:36:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43531 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3GXMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:36:28 -0400
Date: Wed, 24 Jul 2013 15:36:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 1/7] usb: phy: msm: Move mach depndend code to
 platform data
Message-ID: <20130724123619.GG17962@radagast>
Reply-To: <balbi@ti.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
 <1373384833-18077-2-git-send-email-iivanov@mm-sol.com>
 <20130724123442.GF17962@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MP5ln1Rcf9Bvi+ZW"
Content-Disposition: inline
In-Reply-To: <20130724123442.GF17962@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP5ln1Rcf9Bvi+ZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2013 at 03:34:43PM +0300, Felipe Balbi wrote:
> On Tue, Jul 09, 2013 at 06:47:07PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >=20
> > This patch fix compilation error and is an intermediate step
> > before the addition of DeviceTree support for newer targets.
> > Fix suggested here: https://lkml.org/lkml/2013/6/19/381
> >=20
> > Cc: David Brown <davidb@codeaurora.org>
> > Cc: Daniel Walker <dwalker@fifo99.com>
> > Cc: Bryan Huntsman <bryanh@codeaurora.org>
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> >=20
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>=20
> I need Acks for arch/arm/*, I'll drop these from my TODO until it's
> resent with proper Acks.

btw, you better start using drivers/reset for device-side reset
assertion-deassertion.

cheers

--=20
balbi

--MP5ln1Rcf9Bvi+ZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78pDAAoJEIaOsuA1yqREYuQP/0fkmagmOboqrXi+LyeyDCQQ
84lEjoefrf52NlJHUESINM9a/QtYb2a+cbXixpAN7DYFHsvbuJbufINSh3xsTy6Z
aIt6kRCcbpG2Poeg1CQhqSIGtdvZc5tn22nw36r0iVIGBLuJYj3McQ6pzbvamuqT
KanuHn4O/ZE27FT39YYCeZRn4A6evsJkSjF8Erwt47B60fkaipajhDk8MHC4Bq/U
bc3kHIUyzlG1LSkW6T0SxiE5QnlydDtwQuzEHL+8saQW85fhVBLUw4IkdmBalgbW
aFXBA1CGAM9NUub3w57T/nQ15cq2cpLpU5pK4F24to5YQinEKkrj6P7AUxSErU3j
ph5Qyf3vsTtzaqt+Hhrp2JUvQOFEsSUZA3SxK28XqDFgLSHmgaQ/q5VW9ICEZpNh
8ggHkcEKpf2xm2UURtOlNZUNUts7YZSCRQFRgoErFqtZPnKI5LJxQosB7Sp5NgY3
1WifEbEOpmS5WjCkYUAtaW31PfFQwy5g58XD9lq52M7BeOMvu0OXySC7w9mXWQmt
lp7pFXEJLJHl0dol5nAPveJXSlXFIEO6dotZtYNFGfAKK+C7xmbmcPclN+J6GdJM
+eC5u82uVX5JDBBLztHOjCKIoq5LH8sTv9IWyAwpa7yDEcoWzZTXegU0XAd6DjsO
faC5/vavMLvW/oteZJTn
=r0uD
-----END PGP SIGNATURE-----

--MP5ln1Rcf9Bvi+ZW--
