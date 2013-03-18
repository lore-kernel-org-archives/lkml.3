Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3CRL7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:59:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10869 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3CRL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:59:45 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-9e-514701b0d217
Message-id: <1363607942.14386.73.camel@kjgkr>
Subject: Re: [PATCH 13/19] f2fs: fix return value of releasepage for node and
 data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 18 Mar 2013 20:59:02 +0900
In-reply-to: <CAKYAXd9qmaJksB9cOYGBpGb6h4mdQj7J-OwWttRprps8=i0RKA@mail.gmail.com>
References: <1363585931-8441-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd9qmaJksB9cOYGBpGb6h4mdQj7J-OwWttRprps8=i0RKA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-jSvUK/7q8zTcVRoHsTOt"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zfd0NjO6BBps+yVrs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVs/LqNuWCeWMXyyzOYGxj/C3UxcnJICJhI3H5/iRnC
	FpO4cG89G4gtJLCMUeLtFB6YmrXr7wHVcAHFFzFKbJ91lwWi6DWjxJ992iA2r4CuxMrN39i7
	GDk4hAVCJFomBIGYbALaEpv3G0BUK0q83X+XFSQsIqAmMeFZKkiYWSBTYs7ryawgNouAqkTT
	5ClgF3AKBEvMfXeJEWJrL6PEiY+TwbbyC4hKnGz9xAjRXCUxt7mJEeJMJYnd7Z3sENcISvyY
	fI8FpFlC4B67xNcPR5ggNghIfJt8iAXkCAkBWYlNB6Bel5Q4uOIGywRG8VlIxs5CMgoirinR
	uv03O4StLbFs4WtmCNtWYt2691A1NhKbri5ghLDlJba/ncO8gJF9FaNoakFyQXFSepGxXnFi
	bnFpXrpecn7uJkZIPPbvYLx7wPoQYxXQiROZpUST84HxnFcSb2hsZmRhamJqbGRuaUYVYSVx
	XrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjCoyB+cUXDeadyR974q6Wbv1XosvF3tk
	fUi9PyTW57jDdeO/DzYsceFV+P/4Q0bujq9X+js++rd9fHKI9eATUZs0pjalC9///naZP6X3
	x6n27Z2hL8919c0uiXTbtVnwm1fmgUrtNVJ3lh1Nz9mt9DS6UjZucvAUyyu7I00W9Ox5zfFk
	Y5zqpgIlluKMREMt5qLiRABQnDJY9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd0NjO6BBkt6JCz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzNn7dxlwwT6xi
	+eUZzA2M/4W6GDk5JARMJNauv8cMYYtJXLi3nq2LkYtDSGARo8T2WXdZQBJCAq8ZJf7s0wax
	eQV0JVZu/sbexcjBISwQItEyIQjEZBPQlti83wCiWlHi7f67rCBhEQE1iQnPUkHCzAKZEnNe
	T2YFsVkEVCWaJk9hA7E5BYIl5r67xAixtZdR4sTHyWBb+QVEJU62fmKEaK6SmNvcxAhxppLE
	7vZOdohrBCV+TL7HMoFRcBaSsllIUhBxTYnW7b/ZIWxtiWULXzND2LYS69a9h6qxkdh0dQEj
	hC0vsf3tHOYFjOyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj/ZnUDsaVDRaHGAU4GJV4
	eHesdwsUYk0sK67MPcSoAjTn0YbVFxilWPLy81KVRHgdbwOleVMSK6tSi/Lji0pzUosPMU5k
	BIbHRGYp0eR8YJLKK4k3NDYxM7I0MrMwMjE3p6WwkjjvgVbrQCGB9MSS1OzU1ILUIpijmDg4
	pRoY9ZLC3Dg+7lGa41J6+uIN1rqabUf4vBQMCx7+j68On/ilcNNiVn+1OQ/ON8nt6b7aUTEx
	6adpx3qzSU0+nnzJs85YWb//nGEkmNvvum8Jd6jfk9MJVeoq8o98p76f5nMw4HTDTNXn0lxW
	F1Zuu5Uw4+ahFqua30HPvNgrzD6p60kaLNi1vyVWiaU4I9FQi7moOBEAzkPQ4nYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jSvUK/7q8zTcVRoHsTOt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-18 (=EC=9B=94), 20:39 +0900, Namjae Jeon:
> 2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > If the return value of releasepage is equal to zero, the page cannot be
> > reclaimed.
> > Instead, we should return 1 in order to reclaim clean pages.
> >
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/data.c |  4 +++-
> >  fs/f2fs/node.c | 13 +++----------
> >  2 files changed, 6 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 6616137..cd6b2cc 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -680,8 +680,10 @@ static void f2fs_invalidate_data_page(struct page
> > *page, unsigned long offset)
> >
> >  static int f2fs_release_data_page(struct page *page, gfp_t wait)
> >  {
> > +	if (PageWriteback(page))
> > +		return 0;
> >  	ClearPagePrivate(page);
> > -	return 0;
> > +	return 1;
> >  }
> I have a question.
> Although PageWriteback is already checked in try_to_release_page,
> we need to check it again in f2fs_release_data_page ?

Oh, I made a mistake.
No need to check that.
Thanks,

>=20
> Thanks.
>=20
>=20
> > 1.8.1.3.566.gaa39828
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jaegeuk Kim
Samsung

--=-jSvUK/7q8zTcVRoHsTOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRRwGGAAoJEEAUqH6CSFDSI9IP/2x0SdghO6GU9KYesKH6KKXs
YSCNeMht74zNZ4kET9Oxb8nUEV+OneTfHVj23R7iJGgxa5mhL4bego/wKintMIPT
gMzaOfGkuuAmtzgeUqz80UXoExjJigyh8F/T4f+p81QTgwB/VciEMdt9ZW/gDkvO
Ed/Xbkp9Dc/Gt3Gwf0/DCmUADL0bxUSNJ0P/WMRTfK2S7+WutOpnDlD6u31OzfCn
oZM6nXv1DEc77hDvJLNFSUgb6jXUaSQwzBd1E/AWwrqq5BC8VJh68CvdCqf7TbwH
Qwpf7wgD03dODY+adWQ2CLfugai+ijhWMZQWNpQxQniedQLHexIGJ6tKpInlhbW0
blvF+czhfx+IaXid5EnOmvXl06yCXOASoCpMiyO7QmonEnSRZ/noXvy+SgZPsRvZ
6THaLtZG6HLhqBeDKPIICUnwxyk1EtehmFpI5hdZXa1T4UtrOfs17YE+gH5f3+Lt
hDbInlc4BGn2mizg3qOLYloM0h3AsTN9VUgwbAvxVULG9go8aK+A/sqWYLteHXut
7c0x7yDEfQzfLLDMuA0/EwEIbgUWAE0/zSUYBdtvrKp+G4iCbQ7z5dOICmZ0aK2X
/l+68DkZFgeHmecin3Pbh48WeLTDoRxmBrP3VDIhvC7fA1Tq6BRRu7asXsDFugSH
BbaSkShH+rPMXYcLlZAC
=/Owf
-----END PGP SIGNATURE-----

--=-jSvUK/7q8zTcVRoHsTOt--

