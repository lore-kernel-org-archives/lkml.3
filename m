Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3AaBEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:04:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26907 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3AaBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:04:19 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-68-5109c311fb22
Message-id: <1359594232.22847.56.camel@kjgkr>
Subject: Re: [PATCH 1/3] f2fs: avoid redundant call to has_not_enough_free_secs
 in f2fs_gc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Thu, 31 Jan 2013 10:03:52 +0900
In-reply-to: <1359553622-7449-1-git-send-email-linkinjeon@gmail.com>
References: <1359553622-7449-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-VJBL4LQoxHv3WN4ixRL2"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zQ13Bw5yBBr+nKFvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW03PMu6BWpWHljO2sD4wbBLkZODgkBE4kDE1ewQdhi
	EhfurQeyuTiEBJYxSiz/towNpujRpx/MEIlFjBINExezgiSEBF4zSvx+VAdi8wroStzc+JoR
	xBYWiJE4dXczexcjBwebgLbE5v0GEOWKEm/332UFCYsIqElMeJYKMpJZYBejxLGjS1hAalgE
	VCUW/LwEZnMKuEhc2TuREaLXWaLr+FcmEJtfQFTiZOsnsDizQJXE1f8foO5Uktjd3skOcY6g
	xI/J91hAFkgI3GOX2H33HSPEAgGJb5MPsYAcISEgK7HpADNEr6TEwRU3WCYwis9CMnYWklEQ
	cU2J1u2/2SFsbYllC18zQ9i2EuvWvYeqsZHYdHUBI4QtL7H97RzmBYzsqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzFCIlJqB+PKBotDjAIcjEo8vBqOnIFCrIllxZW5hxhVgOY82rD6AqMU
	S15+XqqSCO8hE6A0b0piZVVqUX58UWlOavEhxiqg5yYyS4km5wOTSF5JvKGxsYmZiamJuaWp
	uSlVhJXEeRlPPQkQEkhPLEnNTk0tSC2CWc7EwSnVwOiVnF961vufCIdb0x9+9/e5TuL8t05v
	T/hssvHqwdu2fPumLj254qIgzy+JVy1cc6oTT/AZKTO/2x3Z9WJpIdtO9xlXLVZlmvybtF7z
	t8liluoOdomvS1uWfl1Zf/7sa/OrDjanlOeGugb9W7Fw4smZzXM9vzdwHBHfMTlC9PCUt7Mq
	OzUnlfcpsRRnJBpqMRcVJwIAey42Ii8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAV3Bw5yBBk0bZCz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzWu55F/SKVKy8
	sZ21gXGDYBcjJ4eEgInEo08/mCFsMYkL99azdTFycQgJLGKUaJi4mBUkISTwmlHi96M6EJtX
	QFfi5sbXjCC2sECMxKm7m9m7GDk42AS0JTbvN4AoV5R4u/8uK0hYREBNYsKzVJCRzAK7GCWO
	HV3CAlLDIqAqseDnJTCbU8BF4sreiYwQvc4SXce/MoHY/AKiEidbP4HFmQWqJK7+/8AGcaeS
	xO72TnaIcwQlfky+xzKBUXAWkrJZSFIQcU2J1u2/2SFsbYllC18zQ9i2EuvWvYeqsZHYdHUB
	I4QtL7H97RzmBYzsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/2Z1A7GlQ0WhxgFOBiV
	eHg1HDkDhVgTy4orcw8xqgDNebRh9QVGKZa8/LxUJRHeQyZAad6UxMqq1KL8+KLSnNTiQ4wT
	GYHBMZFZSjQ5H5ik8kriDY1NzIwsjcwsjEzMzWkprCTOy3jqSYCQQHpiSWp2ampBahHMUUwc
	nFINjKHWFf69V4VqJ0vye2z7kn73m2XFCVEN74WM+/f88CxslfdYYT21p6J5zVmVCff3eDx8
	VXTYdyrz4m8brlxhFqhW3Vrn7eY30TJdydy87UOCyueNXBsXde3s3VLDPfWfzs9stUWipo/P
	u69fz1msu5Zru7jOisgYzuU2F9cVxy9+vGf7iwrfXUosxRmJhlrMRcWJALNlpA12AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VJBL4LQoxHv3WN4ixRL2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-01-30 (=EC=88=98), 22:47 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> After doing a write_checkpoint from garbage collection path if there is s=
till
> need to do more garbage collection, gc_more label is used to jump and sta=
rt
> the process again. And in that process, first step before getting victim =
is to
> check if there are not enough free sections, which is already done before
> doing a jump to gc_more. We can avoid the redundant call to check free
> sections, by checking the gc_type flag which will remain FG_GC(value 1) u=
nder
> this condition.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/gc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 9b5d0aa..0dfdaa5 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -672,7 +672,7 @@ gc_more:
>  	if (!(sbi->sb->s_flags & MS_ACTIVE))
>  		goto stop;
> =20
> -	if (has_not_enough_free_secs(sbi))
> +	if (!gc_type && has_not_enough_free_secs(sbi))

I applied this patch with the following change:
	if (gc_type =3D=3D BG_GC && has_not_enough_free_secs(sbi))

Thank you. :)

>  		gc_type =3D FG_GC;
> =20
>  	if (!__get_victim(sbi, &segno, gc_type, NO_CHECK_TYPE))

--=20
Jaegeuk Kim
Samsung

--=-VJBL4LQoxHv3WN4ixRL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRCcL4AAoJEEAUqH6CSFDSzYsP/i21IsgXkU0CQPcevFl0jdiG
u4QucScGJTHQZzfilfG+bBMl1tGIcePAMpWJF57wSUnsD4kjkIRqGCh91T61ktUU
fpa8Fr/dtiA/RO7ZxQ626VJmcRPV1Bjjized7SGE/9Wlb+/4Zzsiq7b/i10iM80y
KEhDb/fVcFMN59UvkM8u+r//VXxSG+qBANDHbr8doeszveLFkVab/84M2NVpFWvk
cX261q0sgP83/qEgi+dXDpr+ZAZkpTqXmc4IdJo89cnCc2kfHBD5Z6/p1EfztC+p
Izffe2bEllrnCqftSj2rh4YSpKiFAXcOGCyWT6isiuZ0Ez6GTu/yaRTrTg1AUyIW
0uZF0vmBqfpn4bkppq+FMIx1gYgywu/+sBWQYGEDNTwgFmtHpMGcKUeGMvuho4Ab
R13MAp4Xme912aXmhtWcKGReVertga/sjZS9/tXEvwZ0WFZo6tWxFxPjmXx16r65
LPI4s9nkgWVi8maZsolbnAtNjn7KtvVYk93MRHSLrGY0WSnZx6bKSIfAGTmu5+T7
a3uclzGtw/83VE8Jj9RQ1L943G5V1M+dDTpon2qENxP/LQi7HIKTCUz77MicHyVf
hOZWNYmouAM0wFsbn5c31gz45+yKAErwCuNhgjwVIHk/77uKdp6JU9GmPtEYurq5
oDBncDHJQhZjye6aPPpy
=OWPt
-----END PGP SIGNATURE-----

--=-VJBL4LQoxHv3WN4ixRL2--

