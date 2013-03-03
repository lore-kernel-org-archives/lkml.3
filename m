Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3CCESV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 23:18:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40017 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3CCEST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 23:18:19 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-e7-5132cf0997ed
Message-id: <1362284257.14386.1.camel@kjgkr>
Subject: Re: [PATCH 1/5] f2fs: change victim segmap test condition in
 get_victim_by_default
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Sun, 03 Mar 2013 13:17:37 +0900
In-reply-to: <1362195637-20683-1-git-send-email-linkinjeon@gmail.com>
References: <1362195637-20683-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-NP34TRCN5Ug5KlyNlq3B"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zA13O80aBBqsnqVrs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcf7yUqaBBuOLAq71MDYzHBLoYOTkkBEwk3hzuYISw
	xSQu3FvP1sXIxSEksIxR4ums9ewwRb/nTGaCSCxilJh46BJU1WtGiU8TrrCAVPEK6Eic6PrN
	BGILC8RKNFxtBLI5ONgEtCU27zcACQsJKEq83X+XFSQsIqAmMeFZKsgYZoFdjBLHji4BG8Mi
	oCpxftccsDGcAq4S8/v6WSF6XSS+724Hq+EXEJU42foJ7GpmgSqJ5af6WSAOVZLY3d7JDnGO
	oMSPyfdYQBZICNxjl7i94RkzxAIBiW+TD7GAHCEhICux6QAzRK+kxMEVN1gmMIrPQjJ2FpJR
	EHFNidbtv9khbG2JZQtfM0PYthLr1r2HqrGR2HR1ASOELS+x/e0c5gWM7KsYRVMLkguKk9KL
	jPSKE3OLS/PS9ZLzczcxQqKybwfjzQPWhxirgE6cyCwlmpwPjOq8knhDY2MTMxNTE3NLU3NT
	qggrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIulBe0NT6oI6X6mfuq23Te6dk
	RknMPeJ22bSb5Vz1LGv3vthypW7ni1MNxDSabDyYKmb9YP0dtH/Nl9SDC1y07PUUS/pOFbIf
	Uyz4bjRvR1//1nq/H9MNHSvLLaXqH3ErWBS5OTjyHtv6S8ZX//YVl/ktf3ilAsUc2tymJ64X
	6Tp61UDplRJLcUaioRZzUXEiALdnrwn3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAV2O80aBBhcPmVrs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3H+8lKmgQbji
	wKu9TA2MxwS6GDk5JARMJH7PmcwEYYtJXLi3nq2LkYtDSGARo8TEQ5egnNeMEp8mXGEBqeIV
	0JE40fUbrENYIFai4WojkM3BwSagLbF5vwFIWEhAUeLt/rusIGERATWJCc9SQcYwC+xilDh2
	dAnYGBYBVYnzu+aAjeEUcJWY39fPCtHrIvF9dztYDb+AqMTJ1k+MIDazQJXE8lP9LBCHKkns
	bu9khzhHUOLH5HssExgFZyEpm4UkBRHXlGjd/psdwtaWWLbwNTOEbSuxbt17qBobiU1XFzBC
	2PIS29/OYV7AyL6KUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjmn0nvYFzVYHGIUYCDUYmH
	98Uio0Ah1sSy4srcQ4wqQHMebVh9gVGKJS8/L1VJhDd1D1CaNyWxsiq1KD++qDQntfgQ40RG
	YHBMZJYSTc4HJqq8knhDYxMzI0sjMwsjE3NzWgorifMynnoSICSQnliSmp2aWpBaBHMUEwen
	VAPjJA07rpT14qKHOE6onNm/We3OmqDSv6G/uM1+pXJfPX/3KttkvTv7sv4YPY+T7NYuVTum
	/Oa8ykGd25OZPFVPlgrfnfqs8PhZ+9IVy9Yk2zBPsY4KOMR1M2BWWVhJd+7lZ+k/KgQ+n2o4
	+WHKmhf/uzRu/Uuf0Tijx6JBw4FD+dOJ/PyLnXnnlFiKMxINtZiLihMBYt8gWHgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NP34TRCN5Ug5KlyNlq3B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-02 (=ED=86=A0), 12:40 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Instead of checking for victim_segmap(FG_GC) OR
> (gc_type =3D=3D BG_GC) && victim_segmap(BG_GC);
> to continue for the victim selection. The 2 conditions
> can simply be merged and decision can directly be made using 'gc_type'.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/gc.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 94b8a0c..16b4148 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -266,10 +266,7 @@ static int get_victim_by_default(struct f2fs_sb_info=
 *sbi,
>  		}
>  		p.offset =3D ((segno / p.ofs_unit) * p.ofs_unit) + p.ofs_unit;
> =20
> -		if (test_bit(segno, dirty_i->victim_segmap[FG_GC]))
> -			continue;
> -		if (gc_type =3D=3D BG_GC &&
> -				test_bit(segno, dirty_i->victim_segmap[BG_GC]))
> +		if (test_bit(segno, dirty_i->victim_segmap[gc_type]))

Negative.
We should check FG_GC all the time.
Thanks,

>  			continue;
>  		if (IS_CURSEC(sbi, GET_SECNO(sbi, segno)))
>  			continue;

--=20
Jaegeuk Kim
Samsung

--=-NP34TRCN5Ug5KlyNlq3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRMs7hAAoJEEAUqH6CSFDSrasP/iT9hNl8lRF1ERl8oV8iYdp0
JUwIS3LITxjGRKX8LowuaYsAjRvZcn0yv/B8XKZ7UNgt+sTTg8/DSpqmOq8xmw3x
JvKIOl2tu+iQ/yaWPIdfJ7Ie2NUOyb4u1dyvGtFcxnTfHQNj4aKMdm92xxsWw0lg
S6I0Rx12RDOKMt89El5aLQ2HSfc/4jYkSjxptlfnmi7SYd52a6ihliH1jz4/eGDS
hbTaxX2hhD9V6k48RY5qELbODz8/qV5IleEh78BbcfAiccnYnQaWCaTZwgA6yIkH
n9/VMcOmoQ1NJbV8oHIhOHvPo3v/vEa135NH9EzIV/w5nV20srGwM8ywwHw3s8RG
jgZpNU8KtoO6xs7pEJiOazeT+u7SYIt3KejEAWJccH/6Ul72q+Kj5R1qPNt02pEY
H8PNs5jtdFkZEfwP3PU/IhOjuO5mt6Z2Af/VEqrJfDqe5QqD21qcQetZ6kIQjwCE
x9OreKLc2AOz5vlRopZzCzcds+x7kjmJjFSLwb814eIVrKi3Hc4cJnp51ccsD+oH
rrY5Fqf1YI4WwJ7JzRI5k1Ze1hpJhRJ6n32RJGc5NFfGHnuQDtp+9YSKGTV8E2SR
5iOU5lTq9shaDjarAH7F5q3Bzigp9jB7vHBajbG2hxsRZb3xWOTU+Ddt1OH3wYJH
4uEA8HKeOOtSzKkwYRqH
=Qxf1
-----END PGP SIGNATURE-----

--=-NP34TRCN5Ug5KlyNlq3B--

