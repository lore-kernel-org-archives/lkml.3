Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaEWIWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:22:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60857 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaEWIWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:22:05 -0400
Message-ID: <537F04D7.4000201@ti.com>
Date: Fri, 23 May 2014 11:20:39 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>, <tony@atomide.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <bcousson@baylibre.com>,
        <linux@arm.linux.org.uk>, <plagnioj@jcrosoft.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH v3 2/3] ARM: dts: oma3-gta04: Add display support
References: <1399580212-5183-1-git-send-email-marek@goldelico.com> <1399580212-5183-3-git-send-email-marek@goldelico.com>
In-Reply-To: <1399580212-5183-3-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="1xVJCwgQitDeSfiF9inGJJ1rQ4AH41P3w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1xVJCwgQitDeSfiF9inGJJ1rQ4AH41P3w
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/05/14 23:16, Marek Belisko wrote:
> This patch add support for lcd display on gta04 board. Display control
> is connected to spi (used spi bitbang driver).
>=20
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 87 +++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 87 insertions(+)

I can take this via my tree.

Tony, can I have your ack on this?

 Tomi



--1xVJCwgQitDeSfiF9inGJJ1rQ4AH41P3w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfwTXAAoJEPo9qoy8lh71xtQP/1AaQcujZPBukzX0AnjmzEmd
CSFR+ZOMA5kOv8MeVlVydnMCEEkBL9tbfwux34ynxZVLItKlidMJU/8dm+KArT4D
BjZNS1WvlbBrWlEIzIJ0m35GDSElBlbGIbQOmKOqhSAwoSVeBR5A9C3AO/Usnnnu
NGa4E2sjoK8vyTwlBEMzDIuMgawugmfyrFA7nnpRXIHIpA03bIqq4XE5xURTN+LM
OIaQAQ61/M0mdVunfKIkkawSfLD7VS7UfnVvKPY3j9XhAciV415R1/aG+FszGUOX
47xYPsiOmyXS59avWCs9zI+z7MgY+czkybyG85k+rqJ4aHYdLwYhVNwHaJwibDHM
LHkyqRzZT4uylNjY2m81n1jI8cQFyoWsHUtnYiDxRgYOT4BoxaFXBYYYVSmGey/H
9Wy3FkOtSAoAbPZCHiwIL//mhKBXDJjkSOYZT/m0T61S5aGegpEAR6+Yp7Og7FAp
xHC5iUzTmrAf0BEtdaw4elFN5MYv6UJWNDaQOfN/xNa33sIexo3RXaqYUTziReBd
VNOXWQmMC/xftx93J2Efee55Z8pNrhxP4rC2YyXkAybZIrExOS2wa9ttQVQPGXob
a2TZcu+ZHUD/ny+lUAkwJ1NzJ2nx1o3o5z+ZUIvvdg5ODidwUv507BaoIMdR5N63
puJySdapu2eGnhTmM/sX
=JoXo
-----END PGP SIGNATURE-----

--1xVJCwgQitDeSfiF9inGJJ1rQ4AH41P3w--
