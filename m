Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab3JKQGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:06:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54319 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab3JKQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:06:33 -0400
Date: Fri, 11 Oct 2013 11:05:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 01/17] ARM: at91: move at91_pmc.h to
 include/linux/clk/at91_pmc.h
Message-ID: <20131011160528.GV25706@radagast>
Reply-To: <balbi@ti.com>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
 <1381477081-6041-2-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pEAjBjStGYT6H+Py"
Content-Disposition: inline
In-Reply-To: <1381477081-6041-2-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pEAjBjStGYT6H+Py
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 09:37:45AM +0200, Boris BREZILLON wrote:
> This patch moves at91_pmc.h header from machine specific directory
> (arch/arm/mach-at91/include/mach/at91_pmc.h) to clk include directory
> (include/linux/clk/at91_pmc.h).
> We need this to avoid reference to machine specific headers in clk
> drivers.
>=20
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

for drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@ti.com>


--=20
balbi

--pEAjBjStGYT6H+Py
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSWCHIAAoJEIaOsuA1yqREYTUP/jo1tAeSsGLgW8wPWSHBtM2U
3NoEP4BFgO5zen+YQpD39m5yR/LSfMNsUG0l45q4ewRmPAziTOvVTAHBGRmsdLZL
33QAoy56TJj2a3tbweEKKhl6uVaL+phLA3r5MiRClxudGDakqxlTbTSKmNtbvgQV
SlOZQY/n5uR70eYsUmACMn1ss+0lurxQXfaArqi0VXvxjxD7sxGzV2g5l4dC7ERC
elPyT0bbCNCdZChFbd02E0cpe2rBa87xIDyq88qzJiOkLtrtTI0nVwIE6U9FHG9/
IL7cvo8nUq9/j3P/lvw4V13V/FR9GKsLZpK+UM1UyCQuYbTsvyt6DdmQGAVwQjmR
lgTKUuw/MBiZlCz4PDsgtxXjFbRQVguSUSFXC4NATVId9gUU/v75fKrEIOCzTqDD
fYAV1H6qT4A6HouCJz4qaMyspyneIN+52hwKZytZa9EfA2WZSoWGT1RiCm030+XS
IZiasUBKklcxUGz9KdD1a8POJdgjti/BWbG8So5lgSZA6/1D57bYfi0SBCEghLms
kq8ghrkUcx2a0rZrpmPGc3wup6nIKuzniW7ONExQrhAoxqZXq1chb18fT5uTi3oe
zjrsUwUyKuKdErPmhF2rYUcNYb+FFDC4YYMmbVoHvWNmPBaFio3VQ0/28A2MV6Bk
TPeLe4J+AXnU/hvNe2bP
=Q8gr
-----END PGP SIGNATURE-----

--pEAjBjStGYT6H+Py--
