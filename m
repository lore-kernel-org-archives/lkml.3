Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3DVCub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:50:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31586 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3DVCu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:50:29 -0400
X-AuditID: cbfee68e-b7efc6d000000b36-21-5174a574bb04
Message-id: <1366598966.31792.1.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: add REQ_META about metadata requests for submit
 bio
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 22 Apr 2013 11:49:26 +0900
In-reply-to: <1366388860-18735-1-git-send-email-linkinjeon@gmail.com>
References: <1366388860-18735-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-g20TwTWUuRq3HjrG/5MM"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+ZgW7J0pJAg74FHBYXd6daXL97i9ni
	0iJ3iz17T7JYXN41h83ix/R6BzaPnbPusnvsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/Tt
	ErgyZk97yFgwSbhia9s+5gbG6wJdjJwcEgImEjOPn2SBsMUkLtxbz9bFyMUhJLCMUeL2vUNs
	MEU9Z74xQySmM0ps+TCBFcJ5zSjx6MN6dpAqXgEdid8fWhlBbGGBEIk7++YAFXFwsAloS2ze
	bwASFhJQlHi7/y5YWERATWLCs1SQMcwCuxglTv6dC7aMRUBV4szV40wgNqeAq8TH2S9ZIHpd
	JC682wa2il9AVOJk6yewVcwCVRKnGjYwQRyqJLG7vRPqHEGJH5PvsYAskBCYyCFx/t05FogF
	AhLfJh9iATlCQkBWYtMBZoheSYmDK26wTGAUn4Vk7CwkoyDimhKt23+zQ9jaEssWvmaGsG0l
	1q17D1VjI7Hp6gJGCFteYvvbOcwLGNlXMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoREdd8O
	xpsHrA8xVgGdOJFZSjQ5H5gU8kriDY3NjCxMTUyNjcwtzagirCTOq9ZiHSgkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBcdVz+6AZKZt8W3v3bPT/f+3R9tt3vqldkE1rEgp+c0c7MD/d+c86
	b/f33caZoVX/L7QHbigpOBNyiz1PhOfQ3CVvV5y61aP8I2DpPa87b1c8v6Cu8etijvoDs+kZ
	awyMHTNmqp0zTNENnHLu8os9fuVsKW5HvWXdZ38qiH+4deJps3B1lWSu70osxRmJhlrMRcWJ
	ALHc/JUXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xoG7J0pJAg08zmS0u7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRDUw2mSkJqakFimk
	5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsye9pCxYJJwxda2fcwNjNcFuhg5OSQETCR6znxj
	hrDFJC7cW8/WxcjFISQwnVFiy4cJrBDOa0aJRx/Ws4NU8QroSPz+0MoIYgsLhEjc2TcHqIiD
	g01AW2LzfgOQsJCAosTb/XfBwiICahITnqWCjGEW2MUocfLvXDaQGhYBVYkzV48zgdicAq4S
	H2e/ZIHodZG48G4b2Cp+AVGJk62fwFYxC1RJnGrYwARxqJLE7vZOqHMEJX5MvscygVFwFpKy
	WUhSEHFNidbtv9khbG2JZQtfM0PYthLr1r2HqrGR2HR1ASOELS+x/e0c5gWM7KsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxglPGM+kdjKsaLA4xCnAwKvHwTuguCRRiTSwrrsw9xKgCNOfR
	htUXGKVY8vLzUpVEeD93AqV5UxIrq1KL8uOLSnNSiw8xTmQEBsdEZinR5HxgossriTc0NjEz
	sjQyszAyMTenpbCSOO/BVutAIYH0xJLU7NTUgtQimKOYODilGhgTAmy+Cz/dd/oAX0zOrVju
	pZMFpwuGZ1Qo3y78GX3rWsOlz3eTTy/sd9v9grf4MV+E/p05NduL01kf/ulPr3rEkfI1gvHU
	jTsX27bsM3z3UkrI847xpv3RAZdse6rK8gsqU4wYmAMrM0/ZnzmgnHa/JeBg/34Z0VeWVz8/
	mKG9/uiDptdbnnkosRRnJBpqMRcVJwIAldqW6ZgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g20TwTWUuRq3HjrG/5MM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-04-20 (=ED=86=A0), 01:27 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Adding REQ_META for all the metadata requests can help in improving the
> FS performance, if the underlying device supports TAGGING.
> So, when considering the submit_bio path for all the f2fs requests. We ca=
n
> add REQ_META for all the META requests.
> As a precursor to this change we considered the commit
> 4265900e0be653f5b78baf2816857ef57cf1332f 'mmc: MMC-4.5 Data Tag Support'
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/segment.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 1193a26..a2e5de7 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -689,6 +689,9 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>  	if (type >=3D META_FLUSH)
>  		rw =3D WRITE_FLUSH_FUA;
> =20
> +	if (type =3D=3D META)

Should be if (btype =3D=3D META).
Thanks,

> +		rw |=3D REQ_META;
> +
>  	if (sbi->bio[btype]) {
>  		struct bio_private *p =3D sbi->bio[btype]->bi_private;
>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync,

--=20
Jaegeuk Kim
Samsung

--=-g20TwTWUuRq3HjrG/5MM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRdKU2AAoJEEAUqH6CSFDS1+EP/1eIx9sHNoWdPNXKM9X8kG1E
/0jKevODrDQFrr3uJuzpXdm7OrpxsUZgruvSuWifpzpw57AkMpOTfv7VYWClkOR/
9yzPP7dBKtg115tVZb6DathpMSZys8xawBvyCCohyiAVI0Gke/oBKTLUC/T4pas+
kw4g5mvGYnqx5gj/Nn6HUGQV0LYOCrHzqwbng91sAb3nhUETqbCg9HfjtkVbijBs
itBpBP47hTvdzMHdZjW7m/n6RRFqlF9jNmFbjTpDgGttKubHQ8VN6WBLRWd1WgmE
bwUb4nkFZMSbZff74AoI/49ZxXhkCS4/5QfT/idSpdDNoTlHS6Er+oE1cnk2YVR6
WuEEFBZJUGGJ0lLyAta6lC52TRYo8f5M1ymKvwV3Gc4PyWn14Fmm+EqZCMbQH0XO
UKxEoCh5Qf/ACOUgPaeh0eW+BLk5hqVXEC9Oexpda7LVTbAidwB3rx+tIXAbJGAl
sewojqrOTXYAskgtXMMcW0ZkaUUu/ca1ItO6sgCqLI1R29TmDVGU14iAMQvbH4Wj
C5vUNL6Qjid1+ucqsIu0IJbhJ1mIifsz/eyapIcy8AbqN/SDXU1JQ38rb22KxQMd
sztrBmQiepfDizoX0/CIkcx3Iqeg7wG/qZbxYRrrSfwFMYaeUxk3S9iz7qIUE48H
rvVrB9uRxNY1vBSDOW7M
=d+60
-----END PGP SIGNATURE-----

--=-g20TwTWUuRq3HjrG/5MM--

