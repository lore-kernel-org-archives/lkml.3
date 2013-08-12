Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3HLSJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:09:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49855 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab3HLSJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:09:34 -0400
Date: Mon, 12 Aug 2013 13:08:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] usb: gadget: at91_udc: add usb_clk for transition to
 common clk framework
Message-ID: <20130812180851.GF27954@radagast>
Reply-To: <balbi@ti.com>
References: <1375337885-2684-1-git-send-email-b.brezillon@overkiz.com>
 <5208E881.3030205@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f61P+fpdnY2FZS1u"
Content-Disposition: inline
In-Reply-To: <5208E881.3030205@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f61P+fpdnY2FZS1u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 03:52:01PM +0200, Nicolas Ferre wrote:
> On 01/08/2013 08:18, Boris BREZILLON :
> >The AT91 PMC (Power Management Controller) provides an USB clock used by
> >USB Full Speed host (ohci) and USB Full Speed device (udc).
> >The usb drivers (ohci and udc) must configure this clock to 48Mhz.
> >This configuration was formely done in mach-at91/clock.c, but this
> >implementation will be removed when moving to common clk framework.
> >
> >This patch adds support for usb clock retrieval and configuration, and is
> >backward compatible with the current at91 clk implementation (if usb clk
> >is not found, it does not configure/enable it).
> >
> >Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>=20
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I don't have the original, where is it ? Was it not Cced to linux-usb ?
Can someone resend with Nicolas' Acked-by in place ?

--=20
balbi

--f61P+fpdnY2FZS1u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCSSzAAoJEIaOsuA1yqREY9sP/AofRexBZ8tE91CjFNQ1pDBs
27IOAX/ubbz1/Bydv3O7PBX4aemNzU0gibV4FcZJHrF+jcZlwYy555gl3tN5z1O8
Ut9chA+bSPppDxU34CSitjjWAw5bgxdczzC9tCKHjkZDLnBTrxb9otAyFvKwQNxZ
01sT2e/k5ezCz3k/Tl6NuKRp8knn1LcZfEdJkEa4KIGJGRTvkQ4met+D7ikGDZOd
l3QXedn6/WevdtorAKqa0W9zIe9d+0JNTBMB10Rw8w2Go+1lW7KCQISQvczDgkxF
X93QMaWm4++PiOV5C7sob+3gghGOfdVBIim3ZUCoQ5KftBETzayMUDtV2GUnuVkp
s86rZsgGeaQ0XGm035nelxbiOSd/z0V8+Mqps4NRxT24Hu6LGNJiFwuOfxctpDsQ
nrqhtJPR18bVbL70O0Hr3L/Mwj6jWuPoWbU780X9HjXD12MyLJvqR9lGFifgOsYl
00otjfrczIYdv5qDO09jXJTYdzj8/ST4OhN7Vpr3C74NnnScbM3lgtUU8yj0ztT6
x9HkK4DcsUPbh7yse5aK6TNsKLf7yXAdR1z4Bvy42QIXYGwXRVndIh3QMJSC0f8T
9k4xP/+zA6I2eQggSZrtfOwDnx5fDdbNfLR+hKdogPcFCeUIGCJB9sr4wshTFvHK
wfmpzC0K64L2RL6L7ild
=Kgru
-----END PGP SIGNATURE-----

--f61P+fpdnY2FZS1u--
