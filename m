Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3EOEj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:39:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14606 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3EOEj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:39:26 -0400
X-AuditID: cbfee690-b7efc6d000006d92-14-5193117ca8e4
Message-id: <1368592699.11843.10.camel@kjgkr>
Subject: Re: [PATCH 1/2] f2fs: fix inconsistency of block count during recovery
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 15 May 2013 13:38:19 +0900
In-reply-to: <CAKYAXd8r7EcbrPuHJcz9Ft=ienP6gT84QBP8VWUDeKm=v=mcfA@mail.gmail.com>
References: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd8r7EcbrPuHJcz9Ft=ienP6gT84QBP8VWUDeKm=v=mcfA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-FyiqWqBY2dpX7RQvBvNp"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zfd0awcmBBs2nbSyu373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfHt/ynmggNCFTsf
	HWBuYGwR6GLk5JAQMJGY+HQnK4QtJnHh3nq2LkYuDiGBZYwSSzftYIUpOvSpnx0isYhR4l3T
	daiq14wSV7qXMoNU8QroSmxobADrEBbwl3j/9hlQBwcHm4C2xOb9BiBhIQFFibf777KChEUE
	1CQmPEsFCTMLZErMeT0ZrJNFQFXi+9R7LCA2p0CwxOKNjSwQq3oZJS63fAUr4hcQlTjZ+okR
	orlK4v/8/ewQhypJ7G7vZIc4R1Dix+R7YM0SAj/ZJdauucEIsUFA4tvkQywgR0gIyEpsOsAM
	0SspcXDFDZYJjOKzkIydhWQURFxTonX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1dwAhhy0ts
	fzuHeQEj+ypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkNidsIPx3gHrQ4xVQCdOZJYSTc4H
	xn5eSbyhsZmRhamJqbGRuaUZVYSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAW
	Htx2+Mg2QYVIrpnis1YLzb5/ueP8sjtFa8uvKLM8Pr/ldNqfVYrTip1UbSRv7Q+Z+J3ZOLXl
	1+IJ6v+eG21/9WKrrPGt131m83yaBIUSesSPvjBat6HzW8Lyu3ZP5BcZ/PubpjCnrELsKWNb
	q5hq7sEdEUFMzzpdpk78oLE6c9X3t99PXFQUU2Ipzkg01GIuKk4EAHS6De4KAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jAd0awcmBBs8eG1tcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj2/9TzAUHhCp2PjrA3MDYItDFyMkhIWAicehTPzuELSZx4d56ti5GLg4h
	gUWMEu+arkM5rxklrnQvZQap4hXQldjQ2MAKYgsL+Eu8f/sMqJuDg01AW2LzfgOQsJCAosTb
	/XdZQcIiAmoSE56lgoSZBTIl5ryeDNbJIqAq8X3qPRYQm1MgWGLxxkYWiFW9jBKXW76CFfEL
	iEqcbP3ECNFcJfF//n6oQ5Ukdrd3skOcIyjxY/I9lgmMgrOQlM1CkoKIa0q0bv/NDmFrSyxb
	+JoZwraVWLfuPVSNjcSmqwsYIWx5ie1v5zAvYGRfxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iRGcGJ5J7WBc2WBxiFGAg1GJh7cgcFKgEGtiWXFl7iFGFaA5jzasvsAoxZKXn5eqJMJreA0o
	zZuSWFmVWpQfX1Sak1p8iHEiIzA8JjJLiSbnA9NZXkm8obGJmZGlkZmFkYm5OS2FlcR5D7Ra
	BwoJpCeWpGanphakFsEcxcTBKdXA2ND+u0SSN4i3tNTS3ViHT22nbenRrK6lU9PmNV48OtX2
	nlju+kLR9W81Cxd0md7eNn+Leuvxs0InhK/tYntms1DhX4SpCUfVM1W5F//NvxZaiYQFcSzl
	Nqv4tjBhlqrbxRZ2o1rusyq5MU4fNTK39QkeXMzVUD9N/alcmNHWnYWT7/O/Pj1biaU4I9FQ
	i7moOBEAX1V8M4sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FyiqWqBY2dpX7RQvBvNp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-05-15 (=EC=88=98), 12:47 +0900, Namjae Jeon:
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 3df43b4..9641534 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1492,6 +1492,8 @@ int recover_inode_page(struct f2fs_sb_info *sbi,
> > struct page *page)
> >  	new_ni =3D old_ni;
> >  	new_ni.ino =3D ino;
> >
> Hi. Jaegeuk.
>=20
> I have a minor comment.
> > +	if (!inc_valid_node_count(sbi, NULL, 1))
> > +		WARN_ON(1);

Hi Namjae,

Negative since inc_valid_node_count() is not for debugging.
IMO, for readability, we need to make clear what the function call is
used for.
Thank you for the review. :)

> How about change WARN_ON(!inc_valid_node_count(sbi, NULL, 1)); ?
>=20
> Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
> Thanks.
> >  	set_node_addr(sbi, &new_ni, NEW_ADDR);
> >  	inc_valid_inode_count(sbi);
> >
> > --
> > 1.8.1.3.566.gaa39828
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

--=20
Jaegeuk Kim
Samsung

--=-FyiqWqBY2dpX7RQvBvNp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRkxE7AAoJEEAUqH6CSFDSnbUP/2KBdvVlyPZfJuuKS2n7LGVq
Dc6ej1Q4qEjn//q3boEzl9aCpkN0MoRryzxzgg1jk0bynk4jOHU8GZg80axpXTsl
vB0yTTwWfrDuQB2v/ruIxnBJaaOIWRM76bdirMPT99g2t0ePModvtWLCkJS/4jZI
+7gjlB3ZS/PpgAwpPAyqHExRhqmH7sWonmzLPFcUdD0ChKov/jXYdNcdJ7LZhRyd
hVfWOqGI5dtD2vHOD9CjRo8Tc5waDOALF0N0ZNquJQIbXrMNezHsDkf2lhleQuW9
YZp3INHBNveE9LChZpdfQdNuvMsUcwF6u/zCynOSpDQH3+1GIYJtwtsnuPO+i3bw
Lg1FB7shzCsaB9cH5S06yIS8TRbud+9lptC9JJnPp64NRbi3p7S7XA9+uWEOc06Z
LkRYUHKjKSyU3XfwCFCbAP5VraedKDnIvBUn2sMwNsk8aaaqzCR5BIcqh2FdC128
dswjYLOFcXvfK8i7QtOC2Moe/Mb548IpMyjOwNHrF61TEaKwCbYcwygWrGA+5Bvb
vHp2MIiEM0dAw0zfkkN9j3IvMjPIxoWJkbMg4dXVoRCpe7ZT2BuCUeLtjW72cBnW
/7U57K5xElqbijdFpdGJB9q031wZ7od+GjVwz4mV6KBmuVQY7MKYEwnC6mEfQ/9v
+V/r91bwrIDAS86mvqWg
=4YMo
-----END PGP SIGNATURE-----

--=-FyiqWqBY2dpX7RQvBvNp--

