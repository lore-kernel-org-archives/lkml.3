Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3BFElz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:41:55 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29109 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3BFElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:41:49 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-04-5111df0b3fde
Message-id: <1360125680.26950.55.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix to name f2fs GC task as per partition instead of
 per device
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 06 Feb 2013 13:41:20 +0900
In-reply-to: <1360074293-8252-1-git-send-email-linkinjeon@gmail.com>
References: <1360074293-8252-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-JXCX+KxfTlmeyH/Yulhj"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t8zI13u+4KBBjc2iFjs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcmPqEqeCcbEXn06NsDYzrJLoYOTkkBEwkHr05wQhh
	i0lcuLeerYuRi0NIYBmjRHtjDzNM0eGWLYwQiUWMEhM7drNCOK8ZJfrX9LGCVPEK6ErcO9HM
	BmILC8RI/Lv4nKmLkYODTUBbYvN+A5CwkICixNv9d1lBwiICahITnqWCjGEW2MUocezoEhaQ
	GhYBVYnZR2+zgdRwCrhIdOzNhmh1lth4+S/YdH4BUYmTrZ/AjmYWqJKYfOUI1ANKErvbO9kh
	rhGU+DH5HgvIfAmBR+wSn5qWskLMF5D4NvkQC8h8CQFZiU0HoH6UlDi44gbLBEbxWUjGzkIy
	CiKuKdG6/Tc7hK0tsWzha2YI21Zi3br3UDU2EpuuLmCEsOUltr+dw7yAkX0Vo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRkhMSu9gXNVgcYhRgINRiYf3hp5goBBrYllxZe4hRhWgOY82rL7A
	KMWSl5+XqiTCq7ANKM2bklhZlVqUH19UmpNafIixCui5icxSosn5wDSSVxJvaGxsYmZiamJu
	aWpuShVhJXFexlNPAoQE0hNLUrNTUwtSi2CWM3FwSjUwqsrmpNYo7Jy3pWKVYM2s88u2xF78
	FprI+j/zUMxB1t9n3r9Y3XDu176lTQ5v1roWWSt/Xjjpx47JZb5dTzfENPz5sixdL/tayuJD
	Tza+fuiyZ5rytbU3OHZ3KO/j4FQ+KBTNobKXaVvxZYaFV7fx7lvdvNR28RUpte39WVbbwj/d
	EJVvcVTdvUaJpTgj0VCLuag4EQC1p6aVMAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAV3u+4KBBv9W8ljs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3Jj6hKngnGxF
	59OjbA2M6yS6GDk5JARMJA63bGGEsMUkLtxbz9bFyMUhJLCIUWJix25WCOc1o0T/mj5WkCpe
	AV2Jeyea2UBsYYEYiX8XnzN1MXJwsAloS2zebwASFhJQlHi7/y4rSFhEQE1iwrNUkDHMArsY
	JY4dXcICUsMioCox++htNpAaTgEXiY692RCtzhIbL/8Fm84vICpxsvUT2G3MAlUSk68cgbpT
	SWJ3eyc7xDWCEj8m32OZwCg4C0nZLCQpiLimROv23+wQtrbEsoWvmSFsW4l1695D1dhIbLq6
	gBHClpfY/nYO8wJG9lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRH/THoH46oGi0OMAhyM
	Sjy8N/QEA4VYE8uKK3MPMaoAzXm0YfUFRimWvPy8VCURXoVtQGnelMTKqtSi/Pii0pzU4kOM
	ExmBoTGRWUo0OR+YpvJK4g2NTcyMLI3MLIxMzM1pKawkzst46kmAkEB6YklqdmpqQWoRzFFM
	HJxSDYydaz7MPWDNeKhdv/jm0o8FrU8Ndl79E7GjrEDgSeIspp7Ul6+y7IyZXk6X1MtRuZTI
	/GpyiQD3OuYjV79VaVZzhoWtevB/xlSmVXeuqyw63iJ5T0t5weQtMgIOOvcfcS56ecLPNXnK
	IuObUhxTm+xSHny9vHWW7bsJ3x1vLdHwEJTd5xqac/2OEktxRqKhFnNRcSIAhBfG3HcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JXCX+KxfTlmeyH/Yulhj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

How about this?

2013-02-05 (=ED=99=94), 23:24 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> After the commit 2184ad190a79ae2b40b5f5db1fbde5c22db6d310, it allowed
> for naming GC threads based on the device.
> i.e., if we have F2FS formatted partition in different devices - we will
> have their GC thread names after the device. But, when we have a case lik=
e
> 2 or more partitions on the same device having F2FS filesystem.
> In that case we are not able to differentiate between the GC threads.
> So, to differentiate at all possible levels we can use the major/minor of
> the device to have unique identification in the name.
>=20
> Before patch:
> root  9726  0.0  0.0  0  0 ?  S  14:32   0:00 [f2fs_gc-8:48]
> root  9736  0.0  0.0  0  0 ?  S  14:32   0:00 [f2fs_gc-8:16]
> root  9892  0.0  0.0  0  0 ?  S  14:33   0:00 [f2fs_gc-8:32]
> root  9907  0.0  0.0  0  0 ?  S  14:34   0:00 [f2fs_gc-8:32]
>=20
> After Patch:
> root  16756  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-8:18]
> root  16765  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-8:19]
> root  16806  0.0  0.0  0  0 ?  S  14:58   0:00 [f2fs_gc-8:34]
> root  16817  0.0  0.0  0  0 ?  S  14:58   0:00 [f2fs_gc-8:52]
>=20

root  16756  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-sdb1]
root  16765  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-sdb2]

IMO, it would be better to describe like this.
We can simply use bdevname(bdev, name), so if no objection, I'll rebase
this patch with this.
Please, give me your opinion.
Thanks,


> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/gc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 742135a..b0c1f8c 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -91,6 +91,7 @@ static int gc_thread_func(void *data)
>  int start_gc_thread(struct f2fs_sb_info *sbi)
>  {
>  	struct f2fs_gc_kthread *gc_th;
> +	dev_t dev =3D sbi->sb->s_bdev->bd_dev;
> =20
>  	if (!test_opt(sbi, BG_GC))
>  		return 0;
> @@ -101,7 +102,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
>  	sbi->gc_thread =3D gc_th;
>  	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
>  	sbi->gc_thread->f2fs_gc_task =3D kthread_run(gc_thread_func, sbi,
> -				"f2fs_gc-%s", dev_name(sbi->sb->s_bdi->dev));
> +				"f2fs_gc-%u:%u", MAJOR(dev), MINOR(dev));
>  	if (IS_ERR(gc_th->f2fs_gc_task)) {
>  		kfree(gc_th);
>  		sbi->gc_thread =3D NULL;

--=20
Jaegeuk Kim
Samsung

--=-JXCX+KxfTlmeyH/Yulhj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJREd7wAAoJEEAUqH6CSFDSnEUP/RLM5quOPi3zhiq6x0+reBNc
0WmQ/3h7Rd5+7W2NszygK+5Y/SiySkTMNKOFDdRbY4PRqKlHBozPGt3j8uqJa8ed
wspVoIWJ+VfxwUt8Zsi0v2xa4tTlT8L366we24jPh+tHVdwSrR/JVvu3aFLuNgfR
JAb+PgOL7vTfB8E9ENhptQWh+yi/odL9KNmZa6WHTLhUywIE6cfWE7iqpmbDetLy
IgfrccZ++9C/ld/NMBE/x+WVMWhWl1+psOFLPeeLOb73a/6lGKVSsqYi8/hNh9Tb
DMrYiFoSqlC41pqGgOs1j8fO71vZLXcKKpCTKVB7d/n9M0x/0quALvg0GcXZgcFj
fU5SefU8zXugwUDsKIeDh36WPZSu75L5plxkCoAhNPk53qOu9HvM61tfQ13Uu56h
btjFkNMbywvfpn6mENrwz2avBvIfjFT883prr9dR0R6vaiyyfLvD//3Xw5KoXMTv
WbjuI6Ijm/T8nAnkMDiF62jYlTglaJwXIamuLZCRvUYEM7Nr6u3L+17xzWqUhE5/
gFwckPExAe6vWtnbUUImgwJp0njw/xITgY1xEE3CIdqtP6Th6ChOZ2dedE16gUiM
4fUvn3IiMCzwC+62iiaHSBojxq/M74jHCPFZYKh7ix1f6clvZ0cPaTcKIAsZqxk/
c443frOrVOznldTGsgGk
=TA6T
-----END PGP SIGNATURE-----

--=-JXCX+KxfTlmeyH/Yulhj--

