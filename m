Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3CRCUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:20:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17698 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3CRCUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:20:17 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-48-514679df385e
Message-id: <1363573173.14386.70.camel@kjgkr>
Subject: Re: [PATCH 5/5] f2fs: avoid BUG_ON from check_nid_range and update
 return path in do_read_inode
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 18 Mar 2013 11:19:33 +0900
In-reply-to: <1363508840-2954-1-git-send-email-linkinjeon@gmail.com>
References: <1363508840-2954-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-QkQQr4AHcuugn1CMuaLa"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ937lW6BBm+m2Fjs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVs3TWfteCnREX71DnsDYzLRbsYOTkkBEwkLrc8ZYWw
	xSQu3FvP1sXIxSEksIxRYubjjUxdjBxgRdMWc0PEFzFKHLr9HaroNaPEvAk3mUG6eQV0JW5u
	WcgIYgsLZEnM/HOFHaSZTUBbYvN+A5CwkICixNv9d1lBwiICahITnqWCjGEW2MUocfLvXDaQ
	GhYBVYlFDQ/ZQWxOAReJdy9Ps0L0Okus7+8Ei/MLiEqcbP0EtopZoEri3auVLBAPKEnsboeo
	4RUQlPgx+R5U/BG7xIa5ZhDzBSS+TT7EAvGXrMSmA8wQJZISB1fcYJnAKD4LydRZSCZBxDUl
	Wrf/ZoewtSWWLXzNDGHbSqxb9x6qxkZi09UFjBC2vMT2t3OYFzCyr2IUTS1ILihOSi8y1StO
	zC0uzUvXS87P3cQIiciJOxjvH7A+xFgFdOJEZinR5HxgROeVxBsamxlZmJqYGhuZW5pRRVhJ
	nFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2OZ0+xHQT2O3zxYT0j+WGq2e9PpXc5h
	Ia3SycwsRZdMJoaqWNp3Hth2QjuybfPlRIUOtbQX019dXh//6X4si8Hh5zODb76YZZynka+/
	wOpilPW+nlnqqypV5XILrrbMl9zz9TjHLd/g/01ilku85J+YJf6ZtLWsXSrUM2upZHsBw929
	IXtLZiqxFGckGmoxFxUnAgAPcSEw9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAd37lW6BBufWm1js2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbN01n7Xgp0RF
	+9Q57A2My0W7GDk4JARMJKYt5u5i5AQyxSQu3FvP1sXIxSEksIhR4tDt71DOa0aJeRNuMoNU
	8QroStzcspARxBYWyJKY+ecKO8ggNgFtic37DUDCQgKKEm/332UFCYsIqElMeJYKMoZZYBej
	xMm/c9lAalgEVCUWNTxkB7E5BVwk3r08zQrR6yyxvr8TLM4vICpxsvUT2CpmgSqJd69WskAc
	qiSxux2ihldAUOLH5HssExgFZyEpm4UkBRHXlGjd/psdwtaWWLbwNTOEbSuxbt17qBobiU1X
	FzBC2PIS29/OYV7AyL6KUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjin0ntYFzZYHGIUYCD
	UYmH14DHNVCINbGsuDL3EKMK0JxHG1ZfYJRiycvPS1US4W0IcQsU4k1JrKxKLcqPLyrNSS0+
	xDiRERgcE5mlRJPzgWkqryTe0NjEzMjSyMzCyMTcnJbCSuK8B1qtA4UE0hNLUrNTUwtSi2CO
	YuLglGpgnDjXtVzOeWe+lcHnA4FPo2b+2T03fB57sNyLg3mKpd1MAaWurBlO33keP1WSdLQ3
	kj9+bEv8kpqJc1cbTbb+fJXJt2rJ9yZ9+7nLX8wWWsvqnBgQrFp2d4nPGaGnvVOSzc7kpGdX
	cIloGkUuTtjq/mBC5ls7Rp7Lx66v9Eqad929KP7VGSMOJZbijERDLeai4kQA9umCMncDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QkQQr4AHcuugn1CMuaLa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-17 (=EC=9D=BC), 17:27 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> In function check_nid_range, there is no need to trigger BUG_ON and make =
kernel stop.
> Instead it could just check and indicate the inode number to be EINVAL.
> Update the return path in do_read_inode to use the return from check_nid_=
range.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/f2fs.h  |    6 ++++--
>  fs/f2fs/inode.c |    6 +++++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index be7ae70..1dae921 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -515,9 +515,11 @@ static inline void mutex_unlock_op(struct f2fs_sb_in=
fo *sbi, enum lock_type t)
>  /*
>   * Check whether the given nid is within node id range.
>   */
> -static inline void check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
> +static inline int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
>  {
> -	BUG_ON((nid >=3D NM_I(sbi)->max_nid));
> +	if (nid >=3D NM_I(sbi)->max_nid)
> +		return -EINVAL;
> +	return 0;

At this moment, I'd like to apply this patch and remain BUG_ON together
since we should find real bugs in f2fs.
How do you think?

>  }
> =20
>  #define F2FS_DEFAULT_ALLOCATED_BLOCKS	1
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index ddae412..6d82020 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -44,7 +44,11 @@ static int do_read_inode(struct inode *inode)
>  	struct f2fs_inode *ri;
> =20
>  	/* Check if ino is within scope */
> -	check_nid_range(sbi, inode->i_ino);
> +	if (check_nid_range(sbi, inode->i_ino)) {
> +		f2fs_msg(inode->i_sb, KERN_ERR, "bad inode number: %lu",
> +			 (unsigned long) inode->i_ino);
> +		return -EINVAL;
> +	}
> =20
>  	node_page =3D get_node_page(sbi, inode->i_ino);
>  	if (IS_ERR(node_page))

--=20
Jaegeuk Kim
Samsung

--=-QkQQr4AHcuugn1CMuaLa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRRnm1AAoJEEAUqH6CSFDSTTwP/1TczyKSxKCyXNEkiXDcBR/v
qacKxpOXLxLAJGth9EdF/fhK2mBkWQej73CGHNK/Uc+Nq4PPYltX81QhuqRP7wWg
LO86JgnQFO8yaR87jY1G4H2FdD8j0+cf3ZSkAAuiJMt17VP3K4J5W+31MxD5JGcb
Luc0Pb/Ol6EEt6BmoVDx03QINK5NeZBfZJoK/TzZS3xVFh7jHza48/Lqvh1I/e8/
mJOfl3x+ObfR9qfpNTDmSlijEPCuQ6Che1sE6kboaVA8RwGSHsIDpTAKI82yNBN/
V8lvbB23kHL9Cx0ZHTZREphm6mdWVtIOJcURON9SEkg3EnP+E/2h4fkN3pYvX8zI
qpCIk+2GBdhPmPOXTUdPXcdYxheAp/S4e6TpVvMrMh0O3wf7vJv9dcDGVK8Hd1Zu
Ur22L7nnMvgfWshBYjJZCPlkCnP6x9gw5hgckGl2d9fkrkaokMaF/4gSCJn2rCph
7wzwOslvSmI4hLUxmm0dS6nSO4FC3oo9a1+RGVjIGChX+RbQ5kIiP33sLLAPfb+n
uXegLySIU8BdngKK7rQSfAbjPTxYXccilYPgwuCVL6FT69pLRAi0l8V9e4ETQ0Uk
ZzTHfL0Qlws8QMDlwvGqiCPmRQ4eCXlTRHN3CdGrurROXZeKgyt7BspD3Wb1GVmw
o6g9qr5FKpRg+YT4SV/p
=2oRq
-----END PGP SIGNATURE-----

--=-QkQQr4AHcuugn1CMuaLa--

