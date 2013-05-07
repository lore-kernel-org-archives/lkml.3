Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3EGKhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:37:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19706 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3EGKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:37:32 -0400
X-AuditID: cbfee690-b7f136d000000fea-28-5188d96a266b
Message-id: <1367922988.16581.45.camel@kjgkr>
Subject: Re: [PATCH 3/4] f2fs: optimize scan_nat_page()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>
Date: Tue, 07 May 2013 19:36:28 +0900
In-reply-to: <1367853344-28938-4-git-send-email-haicheng.li@linux.intel.com>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
 <1367853344-28938-4-git-send-email-haicheng.li@linux.intel.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-Ix04UW0JPuwbW7E4BVxu"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zI93smx2BBr9tLW4sKLM486yD0eLS
	IneLPXtPslhc3jWHzYHVY+esu+we804Geuxe8JnJ4/MmuQCWKC6blNSczLLUIn27BK6M3y82
	sBesVanYMnM/UwPjErkuRk4OCQETiZkrJzNB2GISF+6tZ+ti5OIQEljGKHFr0T0mmKL3654x
	QSSmM0o0vn0KVfWaUaJ7539GkCpeAV2JVz/mgXUIC5hL3Jq5ASjOwcEmoC2xeb8BSFhIQFHi
	7f67rCC2CFD5xLezwYYyC/QzSnzZ/pANJMEioCrR1DyVBcTmFPCRWLfwLzNEcy+jRO9XeRCb
	X0BU4mTrJ7C9zAJVEq8ObmeGuFRJYnd7JzvEPYISPybfY4GI93JIXGpUhJgvIPFt8iEWkNsk
	BGQlNh2AapWUOLjiBssERvFZSKbOQjIJIq4p0br9NzuErS2xbOFrZgjbVmLduvdQNTYSm64u
	YISw5SW2v53DvICRfRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSCRP2MF474D1IcYqoBMn
	MkuJJucDE0FeSbyhsZmRhamJqbGRuaUZVYSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTAWr2lbPnfNF0+z4renH9d8M/w73TRx27So7yZ6p1cnzA0JkPwhGf6opZBPNyP+aExJ
	uvNaTaaze1ZOzmENS7siVLEq+pD/ZNkGrQD5wPlclxl5Thx9YKWQHai26WnKjI1v0ra9nZPn
	PcnfarHQzMns+5P1jdYFaJlOUclftfL1847IuuTMLXJKLMUZiYZazEXFiQDNIIUcEQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoG7WzY5Ag7UHLCxuLCizOPOsg9Hi
	0iJ3iz17T7JYXN41h82B1WPnrLvsHvNOBnrsXvCZyePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTM
	vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTtME0JD
	3HQtYBojdH1DguB6jAzQQMI6xozfLzawF6xVqdgycz9TA+MSuS5GTg4JAROJ9+ueMUHYYhIX
	7q1n62Lk4hASmM4o0fj2KZTzmlGie+d/RpAqXgFdiVc/5oF1CAuYS9yauQEozsHBJqAtsXm/
	AUhYSEBR4u3+u6wgtghQ+cS3s5lA5jAL9DNKfNn+kA0kwSKgKtHUPJUFxOYU8JFYt/AvM0Rz
	L6NE71d5EJtfQFTiZOsnsL3MAlUSrw5uZ4a4VElid3snO8Q9ghI/Jt9jmcAoOAtJ2SwkKYi4
	pkTr9t/sELa2xLKFr5khbFuJdeveQ9XYSGy6uoARwpaX2P52DvMCRvZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGMGp4pnUDsaVDRaHGAU4GJV4eBVOtQcKsSaWFVfmHmJUAZrzaMPqC4xS
	LHn5ealKIrw3DnYECvGmJFZWpRblxxeV5qQWH2KcyAgMjonMUqLJ+cAEl1cSb2hsYmZkaWRm
	YWRibk5LYSVx3gOt1oFCAumJJanZqakFqUUwRzFxcEo1MO7zNPb7lZ16XXxFx6XMDv2VihqS
	l19Pun4oPVI2+0DDwQP2bZOCr0xLX/rsdUFzR7B5ype5t8Wfet5lW6Yr0b42YcUtq0vfN278
	xXdJ+vJMKTW+cCbmT5cCpl650P1k4j+Tp4taZJU2HJppMqfktsHLx3zJxexzTZfMeyMjNqVm
	W+0v+32yWr5KLMUZiYZazEXFiQC+d1lklAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ix04UW0JPuwbW7E4BVxu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-05-06 (=EC=9B=94), 23:15 +0800, Haicheng Li:
> When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT entries.
>=20
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  fs/f2fs/node.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 1b45dd0..1fe3fe2 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1254,7 +1254,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, =
nid_t nid)
>  	struct free_nid *i;
> =20
>  	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> -		return 0;
> +		return -1;

We should check all the handler of add_free_nid().
So, plz see the below modified patch.

> =20
>  	/* 0 nid should not be used */
>  	if (nid =3D=3D 0)
> @@ -1302,12 +1302,17 @@ static void scan_nat_page(struct f2fs_nm_info *nm=
_i,
>  	i =3D start_nid % NAT_ENTRY_PER_BLOCK;
> =20
>  	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
> +		int cnt;
> +
>  		if (start_nid >=3D nm_i->max_nid)
>  			break;
> -		blk_addr  =3D le32_to_cpu(nat_blk->entries[i].block_addr);
> +		blk_addr =3D le32_to_cpu(nat_blk->entries[i].block_addr);
>  		BUG_ON(blk_addr =3D=3D NEW_ADDR);
> -		if (blk_addr =3D=3D NULL_ADDR)
> -			add_free_nid(nm_i, start_nid);
> +		if (blk_addr =3D=3D NULL_ADDR) {
> +			cnt =3D add_free_nid(nm_i, start_nid);
> +			if (cnt < 0)
> +				break;
> +		}

Here we need to eliminate cnt.

>  	}
>  }
> =20


-----
=46rom e2da02f0ba045f792d166ac8215d04474c06f319 Mon Sep 17 00:00:00 2001
From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Mon, 6 May 2013 23:15:43 +0800
Subject: [PATCH] f2fs: optimize scan_nat_page()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT entries.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
[Jaegeuk Kim: fix handling the return value of add_free_nid()]
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 122200e..e42934e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1254,7 +1254,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i,
nid_t nid)
 	struct free_nid *i;
=20
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
-		return 0;
+		return -1;
=20
 	/* 0 nid should not be used */
 	if (nid =3D=3D 0)
@@ -1302,12 +1302,16 @@ static void scan_nat_page(struct f2fs_nm_info
*nm_i,
 	i =3D start_nid % NAT_ENTRY_PER_BLOCK;
=20
 	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
+
 		if (start_nid >=3D nm_i->max_nid)
 			break;
-		blk_addr  =3D le32_to_cpu(nat_blk->entries[i].block_addr);
+
+		blk_addr =3D le32_to_cpu(nat_blk->entries[i].block_addr);
 		BUG_ON(blk_addr =3D=3D NEW_ADDR);
-		if (blk_addr =3D=3D NULL_ADDR)
-			add_free_nid(nm_i, start_nid);
+		if (blk_addr =3D=3D NULL_ADDR) {
+			if (add_free_nid(nm_i, start_nid) < 0)
+				break;
+		}
 	}
 }
=20
@@ -1655,7 +1659,7 @@ flush_now:
 		}
=20
 		if (nat_get_blkaddr(ne) =3D=3D NULL_ADDR &&
-					!add_free_nid(NM_I(sbi), nid)) {
+				add_free_nid(NM_I(sbi), nid) <=3D 0) {
 			write_lock(&nm_i->nat_tree_lock);
 			__del_from_nat_cache(nm_i, ne);
 			write_unlock(&nm_i->nat_tree_lock);
--=20
1.8.1.3.566.gaa39828





--=20
Jaegeuk Kim
Samsung

--=-Ix04UW0JPuwbW7E4BVxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRiNksAAoJEEAUqH6CSFDS2vMQAIwAaCHYwzMhLv5FZG/xSpr1
x2lHJIx2sj3TP2UCcqGdhA5oBrii6BNRgncfjKpLq6j5kGkL5mHB8MPvUbOHcWBC
uJWcbaeId9zIsxe78f/rJoIzupZlPqEuOrkg6Gc7WIhDpTYizXWlls0zIqxDEtKV
gecrzxsqh4auchhJSG8aEWifeJZvKrKBXZqPMqyon+I6+gjff/ZRQ6Cf9wP6yR0/
U76kkJApPu8mIY7aPKPNpKR9dQcL1t6n5AJybGGCrx1Vnzuav+aX11kD2ZAFucp1
bHTjnhqr6R6ohydk9FvSSb2Qv8+ezEA2cM7xU8n41t9UdPDMYSexIuB4bsx5nt5k
jbGKptE8Qxv2mK2HLW8w3cyDTwNbtvfN9fBvDrhvIejDxQLQU4OpLc8fk0aBso5v
Jd3eQ6Hjmi3o28QmmljE5rnQPXB8cfZdj/XQVs8jC26CC2qJYtld0MLwQC1+VoA/
nvqphKn14k0pQn37Tf2On5Rl0PN22mLt/5T3OBYF9nIMIMF39zuPKJQBOO+S6NbS
uwN4KcC5NiLE80DcG1VpevmNPERQOjo8MhHNLfK9VPyPksf4zGcMhj8LAbUMl9Hm
NhY0PIpQeun2b6C6kHV7eGP+0zVyKLGVD8MFKpDcpXfuK8/WXuE4tgYnR7InigFD
m2r88d01BokkJVOUvFZB
=nsKB
-----END PGP SIGNATURE-----

--=-Ix04UW0JPuwbW7E4BVxu--

