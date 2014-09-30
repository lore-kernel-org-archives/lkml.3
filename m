Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaI3KmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:42:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50518 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaI3KlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:41:24 -0400
Message-ID: <542A88CA.2000404@ti.com>
Date: Tue, 30 Sep 2014 13:41:14 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] framebuffer: fix border color
References: <alpine.LRH.2.02.1409161238560.3150@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1409161238560.3150@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iodI1qUHwJBKaweKlUwkEDaQNqlnAM950"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iodI1qUHwJBKaweKlUwkEDaQNqlnAM950
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 16/09/14 19:40, Mikulas Patocka wrote:
> The framebuffer code uses the current background color to fill the bord=
er
> when switching consoles, however, this results in inconsistent behavior=
=2E
> For example:
> - start Midnigh Commander
> - the border is black
> - switch to another console and switch back
> - the border is cyan
> - type something into the command line in mc
> - the border is cyan
> - switch to another console and switch back
> - the border is black
> - press F9 to go to menu
> - the border is black
> - switch to another console and switch back
> - the border is dark blue
>=20
> When switching to a console with Midnight Commander, the border is rand=
om
> color that was left selected by the slang subsystem.
>=20
> This patch fixes this inconsistency by always using black as the
> background color when switching consoles.

Thanks, queued for 3.18.

 Tomi



--iodI1qUHwJBKaweKlUwkEDaQNqlnAM950
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKojKAAoJEPo9qoy8lh71kHUQAJaFXD1A9yVJUDVuUwnB9iar
Ct6OtOwsJ0Yb9eKXhL82FXLPD1tBL6KCDCghyM86e3QgOPQwHeYfcSWm1GoV9J5D
6g90p6fNX6vwG0P8nS/S3M2jhjQEuctA3TLjKnd2wVqkRdAvShwUplmNmXVvZlnp
hyr0wPH0r7pWd0nFNyD9cDKXz9vrcOitRFrlgnPPPgmgZHbD7M0bwgEWjlWkfB/w
QVG213osh77oRfBVmP+UPHwnr9R8x/4YxEZauJmGsANi8+95srZ5J+TYBzUofISp
IavYpmAc2ZJuyCJhEmIG+ONEoXJ2WwXecsxoH72rEACd4AlWGBN43T2472+Epent
phLtNBVfFBEbdi/32k3ft1vt2HbHsJ7Y9Una7p2EeVee9eFa4hNibgg8kZr5LUOy
U7aydSy47II8QuqUM60V5/jRUqL1n+Nq9R442dAQ5rMuBj/RhFsXY/wW27sEG+kt
bT8uHzvGlhtZobl0B40nu9DcfqmXwRO6NwuulrrUQPmErVkX7AN9kzgzCckInOlf
ofgqpSBmHIc8Jakj2lF6/SPHjnFC9fkV6GQ3WMjDqAYHkXybHwxIQq9cu546Mz+r
JSouwuOwZnPAJjHi2gKM7u2btiy1fdgXtakYdV8tSRK4QcSrf684Msq1irDfNKiU
3fk6VEi7GCAhQH0Gmt/v
=b4sk
-----END PGP SIGNATURE-----

--iodI1qUHwJBKaweKlUwkEDaQNqlnAM950--
