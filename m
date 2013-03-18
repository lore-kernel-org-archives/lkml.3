Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3CRCMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:12:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63258 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3CRCMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:12:14 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e1-514677fcfabb
Message-id: <1363572687.14386.66.camel@kjgkr>
Subject: Re: [PATCH 4/5] f2fs: remove nid_free from f2fs_new_inode
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 18 Mar 2013 11:11:27 +0900
In-reply-to: <1363508828-2920-1-git-send-email-linkinjeon@gmail.com>
References: <1363508828-2920-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-K6Sjow/yA8bRYHrEt2U8"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zoe6fcrdAg6OLhCwu7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunb
	JXBlHH62haXgrVjFrmNfGRsYtwl3MXJySAiYSFw5dJkZwhaTuHBvPVsXIxeHkMAyRomvE3+z
	wRQ9nTCTCSIxnVHiw+cLUM5rRok5246CVfEK6Eo8nvsKbJSwgJPEzeMgNgcHm4C2xOb9BiBh
	IQFFibf777KChEUE1CQmPEsFGcMssItR4uTfuWwgcRYBVYlfOypAyjkFXCT+NRwGKxcScJb4
	fcIJJMwvICpxsvUTI0iYWaBKYlFLKMSVShK72zvZIW4RlPgx+R4LyHQJgakcEm+nnWQCSbAI
	CEh8m3yIBaRXQkBWYtMBqNclJQ6uuMEygVF8FsLUWUgmgdjMApoSrdt/s0PY2hLLFr5mhrBt
	Jdatew9VYyOx6eoCRghbXmL72znMCxjZVzGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKERPPE
	HYz3D1gfYqwCunAis5Rocj4wGeSVxBsamxlZmJqYGhuZW5pRRVhJnFe9xTpQSCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA2PRbtW8X585NDRWRRafP/Ay5YJCnvsFYd5TZuH1iXO3s7FlJHLc
	WH/L3L8z47/LDcl57plHFvlU63Jmrtp1+Xph+uyXHEk8Zx/syw3pmSvOF3nBPriwg+F+XZP+
	UaEdX14VBbz2O5vk2P//bkTt5Dk6RgnL+n5V775lPZ3x6p/zd/WabkzYc1qJpTgj0VCLuag4
	EQDOUzCqEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoO6fcrdAg2eTeS0u7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRDUw2mSkJqakFimk
	5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYxZhx+toWl4K1Yxa5jXxkbGLcJdzFyckgImEg8nTCT
	CcIWk7hwbz1bFyMXh5DAdEaJD58vMEE4rxkl5mw7ygZSxSugK/F47itmEFtYwEni5nEQm4OD
	TUBbYvN+A5CwkICixNv9d1lBwiICahITnqWCjGEW2MUocfLvXDaQOIuAqsSvHRUg5ZwCLhL/
	Gg6DlQsJOEv8PuEEEuYXEJU42fqJESTMLFAlsaglFOJKJYnd7Z3sELcISvyYfI9lAqPgLISq
	WUgyIDazgKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7zAkb2VYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBqeKZ1A7GlQ0WhxgFOBiVeHgNeFwDhVgTy4orcw8xqgDN
	ebRh9QVGKZa8/LxUJRHehhC3QCHelMTKqtSi/Pii0pzU4kOMExmBQTGRWUo0OR+Y4PJK4g2N
	TcyMLI3MLIxMzM1pKawkznug1TpQSCA9sSQ1OzW1ILUI5igmDk6pBsYMM66WPR9FMt8nFc3o
	6qza87jiyq4T6vtU11z5NJtl1TkfgzqBe4kr3u/9cIXz571DmcbOXyYK8MQES0XunGFnxHT+
	sMD1Ez/lbuT2LrsdIyv+5sLatTHxDttE2Ar/CdUrOu5fubPlsP+3uDtMLz9NsNtZs5lL8kFs
	U28+76T1YjnX+wPZv/1VYinOSDTUYi4qTgQA9t/C1ZQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K6Sjow/yA8bRYHrEt2U8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-17 (=EC=9D=BC), 17:27 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> we can remove nid_free from new inode allocation part.
> Since, nid_free is used to check if we need to free alloced nid
> in case of failure.
> Instead we can directly call alloc_nid_failed from that point, as
> there is no dependency in that path.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/namei.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index d4a171b..261d821 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -24,7 +24,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, =
umode_t mode)
>  	struct f2fs_sb_info *sbi =3D F2FS_SB(sb);
>  	nid_t ino;
>  	struct inode *inode;
> -	bool nid_free =3D false;
>  	int err;
> =20
>  	inode =3D new_inode(sb);
> @@ -58,7 +57,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, =
umode_t mode)
>  	err =3D insert_inode_locked(inode);
>  	if (err) {
>  		err =3D -EINVAL;
> -		nid_free =3D true;
> +		alloc_nid_failed(sbi, ino);
>  		goto out;
>  	}
> =20
> @@ -70,8 +69,6 @@ out:
>  	unlock_new_inode(inode);
>  fail:
>  	iput(inode);
> -	if (nid_free)
> -		alloc_nid_failed(sbi, ino);

We should call alloc_nid_failed() after iput() is completed.
Otherwise, another f2fs_new_inode() is able to get this just-released
nid before iput(). In such a case, insert_inode_locked() can return
-EBUSY or iput() can free this newly allocated inode due to the i_lock
race.
Thanks,

>  	return ERR_PTR(err);
>  }
> =20

--=20
Jaegeuk Kim
Samsung

--=-K6Sjow/yA8bRYHrEt2U8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRRnfPAAoJEEAUqH6CSFDSGHIP/0z2HKYAiICxpB96giIBBcPD
8KPyKpoH/DH50J7QQ8zQdPNvlY/77iPIe60KbnFKsCVuqkfk/4cJAkZwmdvJL4sb
DTaWWbeqUyFB1Y+bwBcIXVL7IphxqAcoZnGMkhXGvxo0dXpPb6+npHWIItc7L0tg
t6Nv12Ur75EsAWW6I9cpfwuBxGJPBQsz9RrS+clIoE0hobkLMPjSywWqQLU33i6J
fuoXutqlCMByewuZUsFD0w3BWj/vohYdeVAXRuRG/qMxFIky5dRzBJxhwSYcM//b
PXeWnVGuN+4xVKEQjQVVhHER03lxeyeEULVOhNnAmFnvQgEoL798EBtzZcHKBqlR
sS2M1WidKWCICMdnQfkpdnyotIcKRKW8gEHvUZwwrVqq0xP5QkSpKMc3y62gFX8V
MTdTeGTjylCfLzBxgPjP0ecxLBT1e6HL4zaKL86BnkZlXOqnYd39SB43tIx3N3lZ
qGpDtW9BfsuoRXPKwTTfqawfST1gG2n/HUQiE7V6ZATcj1bVCa5WTVCJhbYAI77o
Zib9HDg39i0rxENU7PKqnuFUwQzrAwq2BGaGIgy6wArI98ZYyGsMaiT73Lz0xf1L
/8ltIQ5qdDAlQPrnPqIkhYlPeFDfeBPp39W4O3RI12FOdo3XOhQqoCOjDlqLDXmw
frWHoc1+wKp5dNuOHqbi
=mWtY
-----END PGP SIGNATURE-----

--=-K6Sjow/yA8bRYHrEt2U8--

