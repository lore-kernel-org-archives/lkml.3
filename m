Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353Ab3DIIz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:55:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58140 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935034Ab3DIIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:55:56 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-44-5163d79a4d9a
Message-id: <1365497702.4353.67.camel@kjgkr>
Subject: Re: [PATCH] f2fs: move f2fs_balance_fs from truncate to punch_hole
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jason Hrycay <jhrycay@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        C.Fries@motorola.com, jason.hrycay@motorola.com
Date: Tue, 09 Apr 2013 17:55:02 +0900
In-reply-to: <51636BFC.6040607@gmail.com>
References: <51636BFC.6040607@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-4mYVdMhFFRoMgCyxsLXP"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zfd1Z15MDDZYuFrbY9mkii8Xbf+eZ
	La5/3sBmcWmRu8XlXXPYHFg9ds66y+6xe8FnJo+eU2+ZPT5vkgtgieKySUnNySxLLdK3S+DK
	aJpzmLFgglTFpPOXGRsYb4p2MXJySAiYSDT+ecUEYYtJXLi3nq2LkYtDSGAZo8SD9a9Zuxg5
	wIpWdttBxBcxShz4foodwnnNKHF+4lOwIl4BHYlVC1NBBgkLeEt0rtrDBhJmE9CW2LzfACQs
	JKAo8Xb/XVYQW0RARWLH2y9gNrNAtcS+Z6sYQWwWAVWJObNesoC0cgpoSvTutYZo1ZA4s341
	WDm/gKjEydZPjBCtVRJX+t5Dna8ksbu9kx3E5hUQlPgx+R4LyJUSAr0cQHNOMUPMF5D4NvkQ
	C8RbshKbDjBD9EpKHFxxg2UCo/gsJGNnIRkFEdeUaN3+mx3C1pZYtvA1M4RtK7Fu3XuoGhuJ
	TVcXMELY8hLb385hXsDIvopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJJL7dzDePWB9iLEK
	6MSJzFKiyfnARJBXEm9obGZkYWpiamxkbmlGFWElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYxN9nNyn1zKkhfjmxoc7DrH+VeF49/phanmXHNStyybnX15Q4E0y72py9dv+cLX
	FG+sslL5Lq/UuU1Rlps2Fm3g07f7wlXT6ME+MeeMz1aBfazWhVm39i/6VHtsv+flKRKiP9nv
	XNRk0Tq68UnGs6ZfNp0ipZpFPw5dvH8mdnmL2nrPpWKMrjOVWIozEg21mIuKEwGei6n8EQMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t9jAd1Z15MDDRYf4bPY9mkii8Xbf+eZ
	La5/3sBmcWmRu8XlXXPYHFg9ds66y+6xe8FnJo+eU2+ZPT5vkgtgiWpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qukUJaYUwoUCkgsLlbSt8M0
	ITTETdcCpjFC1zckCK7HyAANJKxjzGiac5ixYIJUxaTzlxkbGG+KdjFycEgImEis7LbrYuQE
	MsUkLtxbz9bFyMUhJLCIUeLA91PsEM5rRonzE5+ygjTwCuhIrFqYCtIgLOAt0blqDxtImE1A
	W2LzfgOQsJCAosTb/XdZQWwRARWJHW+/gNnMAtUS+56tYgSxWQRUJebMeskC0sopoCnRu9ca
	olVD4sz61WDl/AKiEidbPzFCtFZJXOl7zwRxppLE7vZOdhCbV0BQ4sfkeywTGAVnISmbhSQF
	EdeUaN3+mx3C1pZYtvA1M4RtK7Fu3XuoGhuJTVcXMELY8hLb385hXsDIvopRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjOE08k97BuKrB4hCjAAejEg/vhSdJgUKsiWXFlbmHGFWA5jzasPoC
	oxRLXn5eqpIIb7dhcqAQb0piZVVqUX58UWlOavEhxomMwNCYyCwlmpwPTG55JfGGxiZmRpZG
	ZhZGJubmtBRWEuc92GodKCSQnliSmp2aWpBaBHMUEwenVAOjybO/aa+cvWrjJ96cu+p6n+dh
	Q2MXlszkjYWJRwTM5Rh7ippeLcqoSd14b1130qYrNjs+xUUZnI7Ped/SrHqP/8nGF+Ef2Rfs
	DLGf35D1aFX9m+mRjK+fFe9exFz4md2+PoT37bT6zkd2T3KvzShbOy37um3Jwmvf1RIFBPfa
	/zBt7dJ0rXBSYinOSDTUYi4qTgQAiWxL+5IDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4mYVdMhFFRoMgCyxsLXP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-04-08 (=EC=9B=94), 20:16 -0500, Jason Hrycay:
> From: Jason Hrycay <jason.hrycay@motorola.com>
>=20
> Move the f2fs_balance_fs out of the truncate_hole function and only
> perform that in punch_hole use case.  The commit:
>=20
>   ed60b1644e7f7e5dd67d21caf7e4425dff05dad0
>=20
> intended to do this but moved it into truncate_hole to cover more
> cases.  However, a deadlock scenario is possible when deleting an inode
> entry under specific conditions:
>=20
>  f2fs_delete_entry()
>      mutex_lock_op(sbi, DENTRY_OPS);
>      truncate_hole()
>          f2fs_balance_fs()
>              mutex_lock(&sbi->gc_mutex);
>              f2fs_gc()
>                  write_checkpoint()
>                      block_operations()
>                          mutex_lock_op(sbi, DENTRY_OPS);
>=20
> Lets move it into the punch_hole case to cover the original intent of
> avoiding it during fallocate's expand_inode_data case.

Agreed.
Thanks,

>=20
> Change-Id: I29f8ea1056b0b88b70ba8652d901b6e8431bb27e
> Signed-off-by: Jason Hrycay <jason.hrycay@motorola.com>
> ---
>  fs/f2fs/file.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index e031f57..155b362 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -390,8 +390,6 @@ int truncate_hole(struct inode *inode, pgoff_t pg_sta=
rt, pgoff_t pg_end)
>  		struct dnode_of_data dn;
>  		struct f2fs_sb_info *sbi =3D F2FS_SB(inode->i_sb);
>=20
> -		f2fs_balance_fs(sbi);
> -
>  		mutex_lock_op(sbi, DATA_TRUNC);
>  		set_new_dnode(&dn, inode, NULL, NULL, 0);
>  		err =3D get_dnode_of_data(&dn, index, LOOKUP_NODE);
> @@ -435,6 +433,9 @@ static int punch_hole(struct inode *inode, loff_t off=
set, loff_t len, int mode)
>  		if (pg_start < pg_end) {
>  			struct address_space *mapping =3D inode->i_mapping;
>  			loff_t blk_start, blk_end;
> +			struct f2fs_sb_info *sbi =3D F2FS_SB(inode->i_sb);
> +
> +			f2fs_balance_fs(sbi);
>=20
>  			blk_start =3D pg_start << PAGE_CACHE_SHIFT;
>  			blk_end =3D pg_end << PAGE_CACHE_SHIFT;
> -- 1.8.0

--=20
Jaegeuk Kim
Samsung

--=-4mYVdMhFFRoMgCyxsLXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRY9dnAAoJEEAUqH6CSFDSTvMP/R5xJiQxn46iuIMTYP/rpCh0
c9PUQMTY3jUIbkXKuvE8nAmBRjrkwgZaN9h2zzv9dK/BeE7vXg/sWPPTXq/sCrre
ah8DylWjX426XZjDGf13cMPH2zvnB+pEZIUrXCxd5VjfTTXSKRIqlBPf0LAFsCTF
O4HoOGMEkvA87H7adDdGP14OxVyw9JF/AetEf3o8Zr+LPIByWys94WVWDrILdFAE
2Q2T1FOPuPOqB3tXCF1Ln1vTKBaT7K5ZHnx4aU+r0SuKr6rviUFs0yVAEsv02kSH
h4jKqjqQhnoN4mcE3KruqJwtY+tR6z3L9hUlmxqCO6X2MPAHznXolxKTEWIj3WLY
96BQPn84s8r1vnAK/tTG6ohcJvmGkbSBGOUmPvb6/JKm6G2Vbg2viLqIO9YOrcaG
P+Thb9rCs6SX0u0MPJHsxeoLJ5GL8zmtPNK4lx4k20TafwzvdCeMesG/OBD8lziR
TfOJeTUA/0QvD7aorgJezjCcLkyUFmrAvRqpOUZ5UWbt7AVqqh5nzif3aAgWloGS
sRjUruOjem6cxFSotcEw8qPWlFKDYq9GkRslT/+q4XhjlzRmz0ucE56QTbRhQzy/
Q993rs2Xrilsxqc5l/v4OR8mzBuDYTkyIHIDEZicixzk1m0AR/WO2PAPttSjDFxw
qnp1rMzl0nwtJSMc9Fog
=Mq+C
-----END PGP SIGNATURE-----

--=-4mYVdMhFFRoMgCyxsLXP--

