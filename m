Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3BZXim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:38:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38442 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3BZXik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:38:40 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-42-512d477e2101
Message-id: <1361921882.31428.10.camel@kjgkr>
Subject: Re: [PATCH 1/2] f2fs: read with READ_SYNC when getting dnode page
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 27 Feb 2013 08:38:02 +0900
In-reply-to: <CAKYAXd-KYnxmFmaUdgB6Tv3tR=OjNGwdhjsUW0mcH7QufXunvQ@mail.gmail.com>
References: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd-KYnxmFmaUdgB6Tv3tR=OjNGwdhjsUW0mcH7QufXunvQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-8Hl+AHrJWh8ZaqMEvc+2"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zfd06d91Ag90PZS2u373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfH0/zK2guNiFWuP
	v2FrYOwV7mLk5JAQMJG4svM6I4QtJnHh3no2EFtIYBmjxLPtAl2MHGA13/YldTFyAYWnM0p0
	7NrFAuG8ZpRY9Xw3E0gRr4CuxJLZhiC9wgJeEiuPrGEBCbMJaEts3m8AMVJR4u3+u6wgYREB
	NYkJz1JBwswCmRJzXk9mBbFZBFQlLh45zwxicwoES9x61soMsamPUWLCjEtgRfwCohInWz8x
	QjRXSUw+9gDqfCWJ3e2d7CA2r4CgxI/J98DOlBBo5JC4ebyFEWKDgMS3yYdYIP6Sldh0gBmi
	V1Li4IobLBMYxWchGTsLySiIuKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+
	dg7zAkb2VYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxghUdu/g/HuAetDjFVAJ05klhJNzgdG
	fV5JvKGxsYmZiamJuaWpuSlVhJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBQw
	21cWfGzazAfvyi9P8BUM/iNVbPHOSXvKsSuLUmpNZ3/a2axd0OLPLuue/PyPg2p42Jb0Krub
	S1+qzN42jZf/Q72F8vuG6TUSrtem713ln6ri99WcO7Z1kc1LqZ0bjI2W7M1kOtEZFzqhQ5Jr
	8/k4geey1T8EpFg82qvOOApanmJbVliSpcRSnJFoqMVcVJwIAPtWXq8HAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t9jQd06d91Ag9eTJCyu373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx9P8ytoLjYhVrj79ha2DsFe5i5OCQEDCR+LYvqYuRE8gUk7hwbz1bFyMX
	h5DAdEaJjl27WCCc14wSq57vZgJp4BXQlVgy2xCkQVjAS2LlkTUsIGE2AW2JzfsNQMJCAooS
	b/ffZQUJiwioSUx4lgoSZhbIlJjzejIriM0ioCpx8ch5ZhCbUyBY4tazVmaITX2MEhNmXAIr
	4hcQlTjZ+okRorlKYvKxB4wQdypJ7G7vZAexeQUEJX5MvscygVFwFpKyWUhSEHFNidbtv9kh
	bG2JZQtfM0PYthLr1r2HqrGR2HR1ASOELS+x/e0c5gWM7KsYRVMLkguKk9JzDfWKE3OLS/PS
	9ZLzczcxgpPCM6kdjCsbLA4xCnAwKvHwLrikEyjEmlhWXJl7iFEFaM6jDasvMEqx5OXnpSqJ
	8H48AJTmTUmsrEotyo8vKs1JLT7EOJERGB4TmaVEk/OBqSyvJN7Q2MTMyNLIzMLIxNyclsJK
	4ryMp54ECAmkJ5akZqemFqQWwRzFxMEp1cBoMWfHg+6o2mVRZ7iWvmzi4l1mkNbEdrJceHPG
	mSqmn3fWpv1JrDVfPOv02uz0Vs2HB1V5ltz0WKwTKbHG4M6+Q2s/9csF8J1N+Zia0BZxbKWB
	YsA21nNKm/wOcfYczWbnENvhtyJB6mgCVwgj10JJpSMFXLzTLr3XdhAL87SKkvqu1mYknabE
	UpyRaKjFXFScCAAoBnW5iQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8Hl+AHrJWh8ZaqMEvc+2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-02-26 (=ED=99=94), 18:35 +0900, Namjae Jeon:
> 2013/2/26, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > It must be set READ_SYNC not READA.
> Hi Jaegeuk.
> Could you please elaborate more?
> Why we need to change READA to READ_SYNC over here, when the purpose
> was to read the node page in READ ahead mode.

That point was a reason for me to make this bug before.
This is get_node_page_ra, not ra_node_page, which means that
ra_node_page does actual readahead for another node pages.

In summary, get_node_page_ra tries to:
1. grab or read a target node page for the given nid,
2. then, call ra_node_page to read other adjacent node pages in advance.

So, when we try to read a target node page by #1, we should submit bio
with READ_SYNC instead of READA.

I'll add this to the description.
Thanks,

>=20
> Thanks.
> >
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/node.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index e275218..185454f 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -930,7 +930,7 @@ repeat:
> >  	if (!page)
> >  		return ERR_PTR(-ENOMEM);
> >
> > -	err =3D read_node_page(page, READA);
> > +	err =3D read_node_page(page, READ_SYNC);
> >  	if (err) {
> >  		f2fs_put_page(page, 1);
> >  		return ERR_PTR(err);
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

--=-8Hl+AHrJWh8ZaqMEvc+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRLUdaAAoJEEAUqH6CSFDSYkQP/AveJMvleAchrlahqK/aWm5h
d7bafABQUa3YTGpXUxMX4Pum7EOgibQiLxtzTqG55t2/w3WqU2sIK8x9BxeIyoIq
JB4q1ufZqwGAfQ0wc2UAapnRKCBu7xh8D4nf5U5ijtnwd2/4qNecGUN9bX0YjjAg
iFxMXbN+nJmHoSqjNrbi2Lh4qYKmSKcgcDLxRW3DWDP0T4JqMXKFqmBrgETcX0p9
Phan5C6MFTNCQ1wh0JcFwnlUvhjVG6hmi25wqGi+YzdakyDoRElZnBvDBuKBDtB/
OaRVX8LPqzyUNxxy4JqrTgPZ4l6PsjvaZa1jRq8RoxHTcL+0VrO2oJ50G8i08ror
CXHuLYk45wXpAxhssD+g8Mj2prtoDles2qxOV8Ru4LPZ0Y585us8T+SXnOjx8EYG
SBN7da6n6mTOJpS2Ktf1vqq4GCcsvxJTLGYxyS66skOhrRIw5P4qEagzDcFmPapw
r54sAFaIVKQo4Z+zynPD/JPvOyhRksGH5hy5jbZ9F8YO9TnWDyFN5RLj5Oku3kpD
ytLg08JTqt122xo1oXu+ULeQ0SAu/5KMmvqtsdmWJ21GALOWAPBh6mnNmuIOVwG2
QyX1ra1XazFfGtg24zLTDouoAALGfQ7q83XLRagFJiw0Tw9BmXaBae4qdg5nDZof
fEjpt3M7wrfcyNkj1oFV
=FjU1
-----END PGP SIGNATURE-----

--=-8Hl+AHrJWh8ZaqMEvc+2--

