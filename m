Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbaHZKnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:43:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57640 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbaHZKnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:43:18 -0400
Message-ID: <53FC64BA.9050603@ti.com>
Date: Tue, 26 Aug 2014 13:43:06 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>
CC: Paul Mackerras <paulus@samba.org>, <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9 v2] video: fbdev: aty: use c99 initializers in structures
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr> <1408792831-25615-9-git-send-email-Julia.Lawall@lip6.fr> <20140823152015.GB2074@thin> <alpine.DEB.2.02.1408231749030.2068@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1408231749030.2068@localhost6.localdomain6>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bgjeuaQTJCSS9vwLQmkKiTm36j4bdd88j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bgjeuaQTJCSS9vwLQmkKiTm36j4bdd88j
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 23/08/14 18:50, Julia Lawall wrote:
> From nobody Sat Aug 23 12:48:19 CEST 2014
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> To: Paul Mackerras <paulus@samba.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,Tomi Valke=
inen <tomi.valkeinen@ti.com>,linux-fbdev@vger.kernel.org,linux-kernel@vge=
r.kernel.org
> Subject: [PATCH 8/9] video: fbdev: aty: use c99 initializers in structu=
res
>=20
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Use c99 initializers for structures.
>=20
> A simplified version of the semantic match that finds this problem is a=
s
> follows: (http://coccinelle.lip6.fr/)

This mail had some extra stuff above (From nobody... etc). I cleaned it
up, hopefully correctly.

I've applied the fbdev patches from this series, 2, 7 and 8, for v3.18.

Thanks!

 Tomi



--bgjeuaQTJCSS9vwLQmkKiTm36j4bdd88j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/GS6AAoJEPo9qoy8lh71THkP/i2fdljCBteChMwb8W4CUs3O
uMnL2adeZoxNotMmSj8ErGfDtdfIVid9iJu4Zw2QSGJ8tvfczOlYPkae7m95VN6X
LQqcSpcaicG6QXuKL6V2YMjMDdG+ucrzxUdDZ5g67QA377xRqwm512N4Bq8xSQIz
zPdXqej/6izEWNXw/rtK+doy+JLkqjw2V+EBBjmmKWAniv1hrtZqdmF5aoHhJi6U
4QSWCoADG5sIYq7AL7dij1lqc873kpg2TnnbuBO8n/b18xQwKm9d30NvJ9GTizHp
roIAmQQzqfr7rze+KxFZusEvRbabPui6gWdXoE3BnTeeHLSwHSIxNHK2L5MCE2tE
xag9Dqp9uhbGbtBjG7JxcwihfuVa/tplO471JBtSG1uOeml+D/fQeQ4IqgM1frH4
qgBQqj5PaxABgNOQ8Km7oEd+wxMXGEoH+nb8HzHmU42szHCsT0OH9Kcc1EOyeR7I
we4lOBS3RKfbP6V/TGvpy7Uks940UbEY/msvQUzw1/DRnaX0xLKeF3sSeIqaraox
rFa480NMu9d9eR/R2u9EOUWuYyEA7oNLP1y2JRvtTBic+soOQ5xpgGWdAOV68A28
4PXX9tUGr36bLo+GOhLGrcAkCulrupAVCOep6JmyUnY93P3yJRZRYID0zG5Ss3OA
PA3/TneGj+MvB7vtzYzj
=XqNH
-----END PGP SIGNATURE-----

--bgjeuaQTJCSS9vwLQmkKiTm36j4bdd88j--
