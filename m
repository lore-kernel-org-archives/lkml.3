Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbbALSZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:25:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbbALSZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:25:01 -0500
Date: Mon, 12 Jan 2015 12:23:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v3 3/5] ARM: at91/dt: update udc compatible strings
Message-ID: <20150112182349.GJ6525@saruman>
Reply-To: <balbi@ti.com>
References: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
 <1421060278-27329-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+WOirvrtTKur1pg"
Content-Disposition: inline
In-Reply-To: <1421060278-27329-4-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x+WOirvrtTKur1pg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 11:57:56AM +0100, Boris Brezillon wrote:
> at91sam9g45, at91sam9x5 and sama5 SoCs should not use
> "atmel,at91sam9rl-udc" for their USB device compatible property since
> this compatible is attached to a specific hardware bug fix.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

WARNING: DT compatible string "atmel,at91sam9g45-udc" appears un-documented=
 -- check ./Documentation/devicetree/bindings/
#177: FILE: drivers/usb/gadget/udc/atmel_usba_udc.c:1827:
+       { .compatible =3D "atmel,at91sam9g45-udc" },

WARNING: DT compatible string "atmel,sama5d3-udc" appears un-documented -- =
check ./Documentation/devicetree/bindings/
#178: FILE: drivers/usb/gadget/udc/atmel_usba_udc.c:1828:
+       { .compatible =3D "atmel,sama5d3-udc" },

please fix and resend. Also, when resending, could you add Nicolas'
Acked-by since he's already given it ?

Thanks

--=20
balbi

--x+WOirvrtTKur1pg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtBE1AAoJEIaOsuA1yqREOX0QAKG+AYCe5awpIENaJpAN6X+9
F39MMjXn8AL47M4F9IH4v3ZjVcBoJnOM/gAFaz10YsSWGMogYPikHJY237ddkR2N
Ziuov6LPlZxHqboObEAWZqg9+ItZmP1UlSaiz9tGrpwREYZrI2o5bS766Q3MWHC1
IT4euxHwH9lYGO1VZAowCOoby82UmgAxqub1+RqALS5TdnrvBjOVugifCkvavGuw
1HShbuZ8Y1SbIq4cHq/u5TDHRoFVzc8nzcZCM4q3xlml3/jLsbKoKbUvWbqTLdYl
LmbMq2ru6rScxF/6UDI5YBJP5koEf/Rhce1pwNt4tIzRRwNJ3NeuC6xpPJcK9cei
I1G6e7XzI4KbuT8xrBsSn2Umt+D9YYRGDrx/15wNuPRab32qVCgQFvWrxnYqpHj3
6wNYd3UyZaQBJocwpkVh8sEmRr725D3k9FG1caplVaYXVXMx0ttgtxss2ro8Rc3R
SF6L9i+HLYoE31Q0ziEEX88MAz+4diEzqQOSQP8pToLH0+xNgYIWSAmNbr036vzm
/w42LALWlT8kv2t7rHPtYsfpgXPxh+QULxaMcf+xQIQbo0rFuYI79HKwUOkGPr9k
vWEjJJzmnUmpxaojQyHyHICsXLZRiupMmnwVHoujLialP16fnHcZLHc25J5jR3qB
8QasthDnKrmb6nRPDmhs
=sdiU
-----END PGP SIGNATURE-----

--x+WOirvrtTKur1pg--
