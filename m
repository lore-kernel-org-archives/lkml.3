Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab3D2Xzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:55:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57345 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab3D2Xzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:55:38 -0400
Date: Tue, 30 Apr 2013 09:55:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: build warning while building Linus' tree
Message-Id: <20130430095527.fd4c5ad48ece70c567991416@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Apr_2013_09_55_27_+1000_RPDGrXVlC3UiATPa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Apr_2013_09_55_27_+1000_RPDGrXVlC3UiATPa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
produced this warning:

drivers/video/ps3fb.c: In function 'ps3fb_mmap':
drivers/video/ps3fb.c:712:2: warning: suggest parentheses around '+' inside=
 '<<' [-Wparentheses]

Introduced by commit 11bd5933abe0 ("fbdev/ps3fb: use vm_iomap_memory()").
Sorry I missed this in yesterday's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__30_Apr_2013_09_55_27_+1000_RPDGrXVlC3UiATPa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfwhvAAoJEECxmPOUX5FEwioP/ArhTOzWkmGkkAAFKW4e4OpS
/xiXlmxcRzmo+yiO74spptB8wL2jU4sfiVeZdZrpyxgvnxMy6p+hpvRRP5UZdk6w
ODsBcI16qlt2VlrJIOgjAMrXtOwGC2LPxT6Qnbh5WxLfTwA46EK+7O2uKcesm9xb
zpioGkBx/VOCBU3Zqxp4FbybO4DzuAOGAy1RcSguCkOdJuDyoMabsCP5+hWZzgW+
Ll32ftAlGIVl7f71BZAPt4t/YWq2TCsNJ5RmM5utV4aVNK9xi7iIH7/LXmNFsNwS
4Kp1m+EZxwWzju/fAhu/aj+73xYPU7iN+r2Xz61tvADAt4+JFRZf9cefGJIuY+lA
CHgtxjQhGi0KMQm6NqzNSqkwdtf0+2zIRWqvkFhyl7mXEJTWGaFcQdAUmimWN2qf
WBwhM1To/aBB48ehYsi/tgyyoh2PQVmc/8Xh5qBP9I9l11NnRIdq1OMgbAq9Wh/s
Np7yhnKYiDQr9sV/5HxdxOWSdcpXwaL4Upx1eys+PREYrlgxDiWKhVWt8CkorRpR
UhWWVgApb/hXfBOh0xkTj7jcDqLzo4s1xtAH1GdOq8oNV5tCqBApgB2Yiy2FgEjU
fQDz9ukoBIX0obhlHFnZqyfviAauajLaVZ88l9Q1qqfVNb1BIRZkDUEO3kALkOSF
J5jMn2da3ZC1JFeMmd0f
=ozA8
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Apr_2013_09_55_27_+1000_RPDGrXVlC3UiATPa--
