Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3CCEev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 23:34:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33477 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3CCEet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 23:34:49 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-94-5132d2e7e58b
Message-id: <1362285251.14386.10.camel@kjgkr>
Subject: Re: [PATCH 3/5] f2fs: move f2fs_balance_fs to correct place in unlink
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Sun, 03 Mar 2013 13:34:11 +0900
In-reply-to: <1362195663-20751-1-git-send-email-linkinjeon@gmail.com>
References: <1362195663-20751-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-EJXP8Jo2BpI/fqYpnifs"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zke7zS0aBBtPnWlhc3J1qcf3uLWaL
	S4vcLfbsPclicXnXHDaLH9PrHdg8ds66y+6xe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3
	S+DKONJ7hq1gu3DF2UsfWBoY7wp0MXJySAiYSFy/f4QRwhaTuHBvPVsXIxeHkMAyRol/RxrY
	uxg5wIrmTuGCiE9nlDg35S07hPOaUeLNyZUsIEW8AroSq2cYgwwSFvCT2Pr9ARtImE1AW2Lz
	fgOQsJCAosTb/XdZQcIiAmoSE56lgkxhFtjFKHHs6BIWkBoWAVWJqb1bWEFsTgFXiaVXNjOC
	1AsJuEi83xMFEuYXEJU42foJ7GRmgSqJCc1XWSHOV5LY3d7JDmLzCghK/Jh8jwVkvoTATA6J
	bb+fsEPMF5D4NvkQC8RbshKbDjBD9EpKHFxxg2UCo/gsJGNnIRkFEdeUaN3+mx3C1pZYtvA1
	M4RtK7Fu3XuoGhuJTVcXMELY8hLb385hXsDIvopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMj
	JJ4n7mC8f8D6EGMV0IkTmaVEk/OB6SCvJN7Q2NjEzMTUxNzS1NyUKsJK4rzyl2QChQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTB2hkbFWGSVCD5Y1OvclJuR7G3/fM6ah4YqjerzIgrTlQWY
	a8W7ptT/nnLj0N4p/8+0Wv1nF5XcUVewdplT4QaD5n83pbkkOJOmskwS1Vjb1vr31taleYam
	jcrPvjl5aLbudQ01/x/kv3d7yOOFjabN9/z44v4bez7/Ffa1d3/hg/wbUmtWOyuxFGckGmox
	FxUnAgAgAZIaFAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e+xoO7zS0aBBgfuGFlc3J1qcf3uLWaL
	S4vcLfbsPclicXnXHDaLH9PrHdg8ds66y+6xe8FnJo++LasYPT5vkgtgiWpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWq2kUJaYUwoUCkgsLlbS
	t8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDjSe4atYLtwxdlLH1gaGO8KdDFycEgImEjMncLV
	xcgJZIpJXLi3nq2LkYtDSGA6o8S5KW/ZIZzXjBJvTq5kAWngFdCVWD3DGKRBWMBPYuv3B2wg
	YTYBbYnN+w1AwkICihJv999lBQmLCKhJTHiWCjKFWWAXo8Sxo0tYQGpYBFQlpvZuYQWxOQVc
	JZZe2cwIUi8k4CLxfk8USJhfQFTiZOsnRhCbWaBKYkLzVVaIM5Ukdrd3soPYvAKCEj8m32OZ
	wCg4C0nZLCQpiLimROv23+wQtrbEsoWvmSFsW4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYwcnimdQOxpUNFocYBTgYlXh4XywyChRiTSwrrsw9
	xKgCNOfRhtUXGKVY8vLzUpVEeFP3AKV5UxIrq1KL8uOLSnNSiw8xTmQEhsZEZinR5Hxgissr
	iTc0NjEzsjQyszAyMTenpbCSOC/jqScBQgLpiSWp2ampBalFMEcxcXBKNTBO2yecsDfM1ej6
	VL+OgP0r5z5vupMqc73Qhbv62AKPSIvW91PSQsOsH03c/UPE62DxZ9eKC7779Y8q7Jzj8qZW
	o/bgnZ/s2puF2fwLelNZ1r5ZplXB1jErtj1bcZGoyYtzDsw3N5fXrJQ5whXl8r9o7f43yZ81
	n1/ij6/L4yq5afN5WcpXwdNKLMUZiYZazEXFiQD90zCnlQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EJXP8Jo2BpI/fqYpnifs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-02 (=ED=86=A0), 12:41 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Actual dirty of pages will occur in f2fs_delete_entry so move the
> f2fs_balance_fs just before deletion.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/namei.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 1a49b88..eaa86f5 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -223,8 +223,6 @@ static int f2fs_unlink(struct inode *dir, struct dent=
ry *dentry)
>  	struct page *page;
>  	int err =3D -ENOENT;
> =20
> -	f2fs_balance_fs(sbi);
> -
>  	de =3D f2fs_find_entry(dir, &dentry->d_name, &page);
>  	if (!de)
>  		goto fail;
> @@ -236,6 +234,8 @@ static int f2fs_unlink(struct inode *dir, struct dent=
ry *dentry)
>  		goto fail;
>  	}
> =20
> +	f2fs_balance_fs(sbi);
> +

I think we don't need to do this because of no issues on performance and
reliability.
In addition, it would be better to call f2fs_balance_fs without any
dentry page.

>  	f2fs_delete_entry(de, page, inode);
> =20
>  	/* In order to evict this inode,  we set it dirty */

--=20
Jaegeuk Kim
Samsung

--=-EJXP8Jo2BpI/fqYpnifs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRMtLDAAoJEEAUqH6CSFDS778P/jjKoGf84ApyO/Db/3AAhT2s
t7NSizPyPFOohicSWMK0ylYCsFa60+OZc8HHJW5YQr0/jVnzKHMlJk1qf/plCjju
zC9CV83mVmvbvcmeFw3eC6K6kx/aDDMq8N1z8bQaAcznVsBdK0N/qhjWpQnHkEEP
WkkAyOwhlvpaNMrXlc7V2LXNb+Hh79VzUJawSZnBMlD+oDXDEKfwgz5g52q1Mh2l
XT5gAitRoIDKG7yKPadmTFx2MUJF75OyrHw6AIuKIhGm61IzMeIJ82kbB8+EU+hh
OTpoqzPcwrewccOmGDzkPS0ukONl4hCpV7Yk++7nxsk6WjCvHFxvo9n+aVNtcA0j
ovdRrj4CuESthxTFnufBVEe7OjyaCLtQgF9PNTvirp8KWA9mGOIxlXIQL+vdEqK/
NXaMVRPuUWCzO7uUxWPkUaIViLDeQbLoHY0lHZkeebd4R2D6PBBGg6YwB3fwqllM
OrF9AHXzuH91QRCEK8JDFDDYx+FG2S/s3u+VhYaMA1kIId6RunNyQFq0vC6IcrdU
bj8u4XfeWaoaASkFEB3wNZJP+QS/3GL1Hc5gvGBHHWBiPfbKMwlfNCXUQ6pB1cJT
fpjz8VohPvHQ9D9Mu8GKZnUoAQZXMtjAdLpv5z3aB4A47pmYvvu93I2B4Zj8iaN7
oODKioVaNOQ4O9VSJP1X
=U2du
-----END PGP SIGNATURE-----

--=-EJXP8Jo2BpI/fqYpnifs--

