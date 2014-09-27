Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaI0QrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:47:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52406 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaI0QrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:47:08 -0400
Date: Sat, 27 Sep 2014 11:46:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: Behan Webster <behanw@converseincode.com>
CC: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>, <daniel.vetter@ffwll.ch>,
        <geert@linux-m68k.org>, <laurent.pinchart@ideasonboard.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <robdclark@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] arm, fbdev, omap2, LLVMLinux: Remove nested function
 from omapfb
Message-ID: <20140927164639.GB7076@saruman>
Reply-To: <balbi@ti.com>
References: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
 <1411780253-4492-3-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1411780253-4492-3-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 06:10:53PM -0700, Behan Webster wrote:
> Replace the use of nested functions where a normal function will suffice.
>=20
> Nested functions are not liked by upstream kernel developers in general. =
Their
> use breaks the use of clang as a compiler, and doesn't make the code any
> better.
>=20
> This code now works for both gcc and clang.
>=20
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJun2AAoJEIaOsuA1yqREZOsP/jkvwOXOIAl1Y076UospTf4u
M8DeRHJx8MLor1oPixp0BPxLxLJI+PnLHjn2c0v+shrvgkjbw07UQlJ3F7NSO1q3
Ehhbe0EBKnQDRfvxN5YkA5MJs1a1w/V8MPokKMo/525y9yaaVoD87fgKNNA3uz1c
aUU0bYyLUxeviQ1YSzEzfOeodrDksSNeKqsqgbQIZyl8s1aw2/d2Ek/88u92DTNp
WGM3wAt0c+XYHucUG5YJwBV5kF3C4UVWTN9pjPE5jhEwkWEBnprmg4iFkeABRleo
2qjHJrby2TClpBCCPGfwNxgZjdaHXAkLqoZsVy51PK1ztSWscxcbDsvcjj/Rtp3d
utWsBoS18U9RAtjaYa0nz7SYDRB6XgVeKPJ9EARTosj2Afw10Nc6saVIgXqwgLyP
80+L9pcwCW4n8KVKhpROUf1E/vhNWTtlVI/7KsB5G2XZCPiNmWOfWwm7Bog7XxST
myKIe+W9MtRx3fw2Yk+dEBhwLZAWna1aRbmebs3tjhj763fPnrkDJU1h1cgsvZO/
O265yKDHUmxTWRmIquBvVuglL5iAYNKHNVemjcT5XenX+hz4JuPKR27xehyFlfup
O0p2jpIJTRYnwJmH93PRsw3cu7N9h8pHn96bJxU3+AUoO+N+pSxszz1vvhn4IZS3
C0Ew/UoZe/tPOeRRDGkR
=cC3G
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
