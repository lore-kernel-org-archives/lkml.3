Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3FLPI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:08:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50497 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3FLPIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:08:25 -0400
Date: Wed, 12 Jun 2013 18:06:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [RFC PATCH 32/50] usb: gadget: at91_udc: prepare clk before
 calling enable
Message-ID: <20130612150641.GC15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
 <1370628498-2584-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <1370628498-2584-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 08:08:18PM +0200, Boris BREZILLON wrote:
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>=20
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuI6BAAoJEIaOsuA1yqREp8IQAKuLfLGe6TIA+sTTGZpfEDCp
qrpO4TWS6LemeZT0jY5aZni6nfdYdZQAkFiE37eQTgiRVIPh68dXdXTNCCzdti/u
5kbr5eKGmlpAj7uNDazjgjTx3MKqnnvwFpIwJ54dezmnyq2tQAjO+kQKqRWd2RwA
XEku4QYt2q9GzUk5vB0qdjAGzf42eiBezg7NFpL+OWewHaqIodj51AWZUQzaUg2F
5IpDrndEDIl8HEfhyOc3ykk4Eo517zxwwLHDkes8QJ/SRtVdUNH3wfEzZaDSzkZL
LHNrNyC+Z4pSd3BcGtMDZbfESyib3h8TPb1Qjaw1zQerLWCyKmOD7uXwmwrCP8KG
NwbaH2esC4//Vw4yyV3B+EYt0XtXxikDYrfX2Lzc6n2nXfJ/Tf0DJ9MRH7JQU901
zW6xrFwFbfptTIPBOiabUjxmKHslSUayPBX5MsPaIRhKsfo1t1uDMx2U+YI6O7Oh
mnvA8STZ5Hu9+fiwA4/HLw2GJr1WuXg0yp30HldKd4rF3B+IpNLoaTX/wvaCAGIc
KTRoqYxgfsvzzzINUCWp36YQK1KmwMPubvSpNHwgm50eiFcOF497/WVXhJyWDHwT
LmwWFUnA/wtQZG31FkXyd9X6FcPYPzgTD2Kry/3HPLNYjVkSup/m0LV9lwVaG+Yc
cSVZutrjMZAmwdoHTMUd
=HkAQ
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
