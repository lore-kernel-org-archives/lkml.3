Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3BDBjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:39:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17465 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3BDBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:39:08 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-1f-510f11361886
Message-id: <1359941916.26950.12.camel@kjgkr>
Subject: Re: [PATCH 1/6] f2fs: optimize get node page readahead part
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 04 Feb 2013 10:38:36 +0900
In-reply-to: <1359816711-16252-1-git-send-email-linkinjeon@gmail.com>
References: <1359816711-16252-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-vvDlUES8vn9pYe2ycaRl"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t8zQ10zQf5Ag5YPOhZ79p5ksbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkbFrxnKjgpXLHnl08D40+BLkZODgkBE4kXj8+xQ9hi
	EhfurWfrYuTiEBJYxijxdUYzG0xR77dOsCIhgemMEvefi0EUvWaUWPX3EQtIgldAV+Lp7Ttg
	RcICLhJr1t0CaubgYBPQlti83wCiV1Hi7f67rCBhEQE1iQnPUkHGMAvsYpQ4dnQJ2BgWAVWJ
	i3u3MIPYnAKuEvsaf7CA1AsBjVy31QYkzC8gKnGy9RMjSJhZoEri9ip5iCuVJHa3Q1zJKyAo
	8WPyPRaI+D12iYXd0RDTBSS+TT4ENlFCQFZi0wFmiBJJiYMrbrBMYBSfhTB0FpJBIDazgKZE
	6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7zAkb2VYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxghkSi1g3Flg8UhRgEORiUeXoZffIFCrIllxZW5hxhVgOY82rD6AqMUS15+
	XqqSCO9VI6A0b0piZVVqUX58UWlOavEhxiqg3yYyS4km5wOTR15JvKGxsYmZiamJuaWpuSlV
	hJXEeRlPPQkQEkhPLEnNTk0tSC2CWc7EwSnVwGj/QUs+yePysslN66MLbPd/iLyce39W6CU5
	/Q7ug7zZpVveiS+0O/rTd4d+F/MaE+f0XhOt14FJ6/w2OOw9srtgrp6q4N0ye/vMZ9dOTpuw
	YZPWQRO9Q0K3px37GvSc23Ba+J6Fxrck9gYWzjHnVLiTKsB7cuqbnc9T1q7InJFqYs5qvI/J
	P1uJpTgj0VCLuag4EQDyDe8OKwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jQV0zQf5Ag773KhZ79p5ksbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZGxa8Zyo4KVyx
	55dPA+NPgS5GTg4JAROJ3m+d7BC2mMSFe+vZQGwhgemMEvefi3UxcgHZrxklVv19xAKS4BXQ
	lXh6+w5Yg7CAi8SadbeAGjg42AS0JTbvN4DoVZR4u/8uK0hYREBNYsKzVJAxzAK7GCWOHV0C
	NoZFQFXi4t4tzCA2p4CrxL7GHywg9UJAI9dttQEJ8wuISpxs/cQIEmYWqJK4vUoe4kolid3t
	EBfzCghK/Jh8j2UCo+AshKpZSDIgNrOApkTr9t/sELa2xLKFr5khbFuJdeveQ9XYSGy6uoAR
	wpaX2P52DvMCRvZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGR/kxqB+PKBotDjAIcjEo8
	vAy/+AKFWBPLiitzDzGqAM15tGH1BUYplrz8vFQlEd6rRkBp3pTEyqrUovz4otKc1OJDjBMZ
	gWExkVlKNDkfmJ7ySuINjU3MjCyNzCyMTMzNaSmsJM7LeOpJgJBAemJJanZqakFqEcxRTByc
	Ug2MU+OuJcp2n1uooN53ncfy3zPzfm0VvWuHzuxvuC3zbsLC4hAPhUX/3j1Wy8+OaA9K1l6+
	V8BM4dCai/JBVyqYFnSmHLOye2v1zvUP+4rCrGflPw91vDq54NaphbKrmGLmyAv3iZk06BwL
	q3/0k8tq60Q+88Qzl17fNo4UEdY97L18uvpm2T45JZbijERDLeai4kQAHC3XNHMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vvDlUES8vn9pYe2ycaRl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-02-02 (=ED=86=A0), 23:51 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> We can remove the call to find_get_page to get a page from the cache
> and check for up-to-date, instead we can make use of grab_cache_page
> part itself to fetch the page from the cache.
> So, removing the call and moving the PageUptodate at proper place, also
> taken care of moving the lock_page condition in the page_hit part.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/node.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 33fa6d5..723185b 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -920,15 +920,12 @@ struct page *get_node_page_ra(struct page *parent, =
int start)
>  	if (!nid)
>  		return ERR_PTR(-ENOENT);
> =20
> -	page =3D find_get_page(mapping, nid);
> -	if (page && PageUptodate(page))
> -		goto page_hit;
> -	f2fs_put_page(page, 0);
> -

The reason why we use this is to avoid the lock overhead.
This is a readahead flow, and we don't need to care about real
existence. Let's get and check the status of the page without any locks.
Thanks,

--=20
Jaegeuk Kim
Samsung

--=-vvDlUES8vn9pYe2ycaRl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRDxEcAAoJEEAUqH6CSFDSmvcP/R6BIj9Cu1qMlN9eGoflzUAf
Goi//FvMUJAPV5jTZejZfmZZ00FQTsDrH5T8ogpE6SGkXNdLvGCf8zSb5z1ROvmk
fY4IHO1wfVJjpt1mXtTuRNGYXCp4VkLYH7N+zQZxDWVZ5c770rQUBTDv4AqiZ8/5
GOHsuoqWNT0gtRyi1B+Opcpex8kwYtuDuRMmFx+0dY5GX4bR6hsH3/zTRxbRA6M1
vp7Xre/OX0pK60XEVRnsV8fyRn9wIFyaIsIvanAqgLjV3QbBG8Osm2+Ptl+RMr4n
I57FmBXHFgPKeeLYLm1QUCf5IzmpRKEJitezmwNXeeCnaoH6ZXKygudKFIfUkAUP
aQUOMEMN0FFZGZyy22jpzj+4o4zk7yYkQgr39BR6lje1qvqeyBAA/fXkrth200Sk
rchp1znTUnuSvqEvasUU4NRk+XJ3UNp0iTqhU0aj3dFH0IuSeFeUJDfCZDd2msTt
pjtOXCg/IGEZ7yoHbGqZ2Z/aeiwgyXQ3wTR4DnbFslPxXeQve1gIChMLA+aXesK3
aCWEb56RzoDurjX/eKDYMTH+nmY9Xc29MmJiZrBUHl8cKojCX5Ki96+QFAP4U3GG
5qcq8YowsjfxWOFQD7jQu2jbyV3J3djT08w8qHSya4kVFMg8ASoHDBEhE3VMZU6h
sIRlAIx8/a6d+5+/H5I9
=Pxm9
-----END PGP SIGNATURE-----

--=-vvDlUES8vn9pYe2ycaRl--

