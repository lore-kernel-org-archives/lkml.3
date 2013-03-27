Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3C0BTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:19:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37628 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3C0BTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:19:35 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-16-51524925ffde
Message-id: <1364347128.29882.12.camel@kjgkr>
Subject: Re: [PATCH 2/4] f2fs: do not skip writing file meta during fsync
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 27 Mar 2013 10:18:48 +0900
In-reply-to: <CAKYAXd9UQwGoLP9s3n-h2qdtpOFRbzTBVUkWUw2+XPEFo1k-Ew@mail.gmail.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
 <1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd_z6oWgrRj3dQ=_OieZ1twnoQqhGLaQah5rp_j9ge858A@mail.gmail.com>
 <1364343513.29882.7.camel@kjgkr>
 <CAKYAXd9UQwGoLP9s3n-h2qdtpOFRbzTBVUkWUw2+XPEFo1k-Ew@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-OjnCZ5oB8NCi1mVAHI1j"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zQ11Vz6BAg65X5hbX795itri0yN1i
	z96TLBaXd81hc2Dx2DnrLrvH7gWfmTw+b5ILYI7isklJzcksSy3St0vgymhoFSpYLVnR9HwZ
	cwPjOtEuRg4OCQETiYWdWl2MnECmmMSFe+vZuhi5OIQEljFKbL94jhkiYSLxbftmVhBbSGA6
	o8Tt3XEQRa8ZJVZ/3MYEkuAV0JV41r0DzBYW8JT4d/MpM8gCNgFtic37DSB6FSXe7r/LChIW
	EVCTmPAsFSTMLJApMef1ZLDxLAKqEs/bVoFN4RQIlri+ZhcbROs2JomPm0NAbH4BUYmTrZ8Y
	IXqrJF6uOs8KcaaSxO72TnaIawQlfky+xwJypoTAV3aJ7zc+MkEsEJD4NvkQC8TvshKbDkC9
	KClxcMUNlgmM4rOQjJ2FZBREXFOidftvdghbW2LZwtfMELatxLp176FqbCQ2XV3ACGHLS2x/
	O4d5ASP7KkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQmJ24g/H+AetDjFVAJ05klhJNzgfG
	fF5JvKGxmZGFqYmpsZG5pRlVhJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MNbO
	fnLNa0ViR8CzRK9k7d3yjYpWWtdnLp45SfVy6I5lJyw5k5WX1Epuza7Z3n/x2K6Jz5TfeJh+
	F5pw8YPsiWoBhb5Cj9o5WuEXGxYeU3k9X/mFYW4r18SXLUuNeK3CHke8XrOJe+EPpyq5J3Mv
	FjyTsF5v/8+GUcx58q8rd9Yef/E93qVLbakSS3FGoqEWc1FxIgCjESTVBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jQV1Vz6BAg31fjSyu373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jR0CpUsFqyoun5MuYGxnWiXYycHBICJhLftm9mhbDFJC7cW88GYgsJTGeU
	uL07rouRC8h+zSix+uM2JpAEr4CuxLPuHWC2sICnxL+bT5m7GDk42AS0JTbvN4DoVZR4u/8u
	K0hYREBNYsKzVJAws0CmxJzXk8FWsQioSjxvWwU2hVMgWOL6ml1Qa7cxSXzcHAJi8wuISpxs
	/cQI0Vsl8XLVeagzlSR2t3eyQ1wjKPFj8j2WCYyCs5CUzUKSgohrSrRu/80OYWtLLFv4mhnC
	tpVYt+49VI2NxKarCxghbHmJ7W/nMC9gZF/FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwS
	nknvYFzVYHGIUYCDUYmH1+FfYKAQa2JZcWXuIUYVoDmPNqy+wCjFkpefl6okwmvjGBQoxJuS
	WFmVWpQfX1Sak1p8iHEiIzA4JjJLiSbnAxNZXkm8obGJmZGlkZmFkYm5OS2FlcR5D7ZaBwoJ
	pCeWpGanphakFsEcxcTBKdXA2NGrKV7JNin73u2K4/sE2LeydL/vLMxw7ynX7JS5Y7vdnqXb
	d7P8m37fOv0rx+e/VayezLBiZvequS8v9F24f7Njes37axz3JCeXTN24ia/2bObHtg+b5aQ5
	o92T/v54Ub5ie+T0tDnyZyY51IonHP4RK/Vh7fbJk6QOaPlu0Dk4ZZ/Zimd1qkosxRmJhlrM
	RcWJALT4hu2IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OjnCZ5oB8NCi1mVAHI1j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-27 (=EC=88=98), 09:57 +0900, Namjae Jeon:
> 2013/3/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > 2013-03-26 (=ED=99=94), 09:48 +0900, Namjae Jeon:
> >> 2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> > This patch removes data_version check flow during the fsync call.
> >> > The original purpose for the use of data_version was to avoid writng
> >> > inode
> >> > pages redundantly by the fsync calls repeatedly.
> >> Hi Jaegeuk.
> >> > However, when user can modify file meta and then call fsync, we shou=
ld
> >> > not
> >> > skip fsync procedure.
> >> I have a question.
> >> Which case does user can directly modify meta ? Recovery tool ?
> >
> > The meta means the inode information like atime, mtime, size, and so on=
,
> > which can be modified by setattr() or something other vfs apis.
> > Thanks,
> I understood. Thanks for your explanation :)
> One more,,
> When inode state is  !(inode->i_state & I_DIRTY)), We don't need to skip =
?

Even though fsync writes no data and the inode is clean, we should mark
the inode to recover after power-off-recovery.
Any data and its inode can be written to the disk clearly before fsync
was called.
Thanks,

>=20
> Thanks.
> >
> >>
> >> Thanks.
> >>
> >> > So, let's remove this condition check and hope that user triggers in
> >> > right
> >> > manner.
> >> >
> >> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel=
"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >
> > --
> > Jaegeuk Kim
> > Samsung
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Jaegeuk Kim
Samsung

--=-OjnCZ5oB8NCi1mVAHI1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRUkj4AAoJEEAUqH6CSFDSnRYP/ivPW8JXJ+Tv6GHKRFCceaGb
pCkah7xGdfPtfqW8TZhSYvDUSjeus+7fQ1qCqw84pfB9zRAqCuBnLmruNUMqtBXS
fAyAsMrZ1OqfX3WIjvt8GibdhuK0NehgmyssKx2PkCFPvraBrWoleXjnxBAwgIIU
NNuvM+78atzLjxH1bitezZmJaIq5v2hse+NQU34FZ47s5K+uFkgqgnqrGStM5Wu7
m7CjPe1Dq70ue7zR3Lo/HZ+J733k23kKT7PUvdDQe4wyuWUY9xdcO1G8Ee2RMdWx
f4X29GyafDZXFPzgKWkfLd07daDiYUQYAzPjGJNbqVjTHjFnZBFEv52PwqTioH5I
I9ZfmMTwQ7srihMZhMlSYAwV0yPb9WHsDCcBRb2678LxTIF9Tto7Ee/kHEspW8QW
m846PH3hRCVHv7ZXuLBcL5OYfTtOiaKB2/0lfU6zCh4TN1PEycMrT38zrG3Yem37
pGfMTW5YWn/Ue5GjpdLDc/gzMd8M6O/7+1lZfjh4Y/Z4//duavvSDz0z+XqszxdJ
SJ4sWHQhV4d0k7ZLNRjiTdpWyTT445RkVKhkgXeQPTeKHoZfWalL412Ipdfk8Eg7
oyJ0UIKNZoUUQrF/MREZ4Xcy6vRA3EBjGeLZ1N2kj16LhaxcuSKk1VlUlkKXUkfd
CEQoG3PCRiZmOFQlIgRZ
=HJtZ
-----END PGP SIGNATURE-----

--=-OjnCZ5oB8NCi1mVAHI1j--

