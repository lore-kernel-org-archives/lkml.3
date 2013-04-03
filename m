Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3DCHzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:55:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8715 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3DCHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:55:40 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-97-515be079959d
Message-id: <1364975688.4353.7.camel@kjgkr>
Subject: Re: [PATCH] To add NULL pointer check
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Date: Wed, 03 Apr 2013 16:54:48 +0900
In-reply-to: <alpine.LFD.2.03.1304031224180.21402@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz>
 <1364958193.4353.4.camel@kjgkr>
 <alpine.LFD.2.03.1304031224180.21402@erqung.pbz>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-ijlr8iH0UQ4LcZlv7Gcd"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zA93KB9GBBr/mqFvs2XuSxeLyrjls
	FlevfGe2mHLyB5sDi8f7fVfZPD5vkgtgiuKySUnNySxLLdK3S+DKODNhF0vBJJGKC8dbGBsY
	Nwh2MXJySAiYSLzY9JUVwhaTuHBvPVsXIxeHkMAyRokFN/aywBStv3uCCSIxnVFi74VDLBDO
	a0aJ3uWrmECqeAW0Je71ngPrEBbQk3izfCd7FyMHBxtQfPN+A5CwkICixNv9d8G2iQjISVzd
	uhusnFkgTWJP630wm0VAVWLpmy2MIDangK3EhZ9rGSF2TWSUeLRtGjNIgl9AVOJk6ydGiOYq
	iU+/ehkhLlWS2N3eyQ5xj6DEj8n3wA6VEPjJLnF7xgUmiA0CEt8mg3zAAZSQldh0gBmiV1Li
	4IobLBMYxWchGTsLySiIuKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7z
	Akb2VYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghUTtxB+P9A9aHGKuATpzILCWanA+M+ryS
	eENjMyMLUxNTYyNzSzOqCCuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYOw8J6Nw
	sLVhtVnAexXBGi3FuojAE2d4/eXyNQLKKs+6blokGFU8YanRtdU81z10HMrWf7P+dYJ7mnLc
	+h+aiuI90WWrmntWLxe+nLlvzkq9G17rXidv/Cq/fv/S821bFK9cUC+5/9w8+cJqj2PfV4fo
	d06YwFy5/FZNVUvJfVWFejOO2ctdVymxFGckGmoxFxUnAgBfoubUBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jQd3KB9GBBr13FS327D3JYnF51xw2
	i6tXvjNbTDn5g82BxeP9vqtsHp83yQUwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZpyZsIulYJJIxYXjLYwNjBsEuxg5OSQETCTW3z3BBGGLSVy4t56ti5GLQ0hgOqPE
	3guHWCCc14wSvctXgVXxCmhL3Os9xwJiCwvoSbxZvpO9i5GDgw0ovnm/AUhYSEBR4u3+u6wg
	toiAnMTVrbvBypkF0iT2tN4Hs1kEVCWWvtnCCGJzCthKXPi5lhFi10RGiUfbpjGDJPgFRCVO
	tn5ihGiukvj0q5cR4lIlid3tnewQ9whK/Jh8j2UCo+AsJGWzkKQg4poSrdt/s0PY2hLLFr5m
	hrBtJdatew9VYyOx6eoCRghbXmL72znMCxjZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	p4RnUjsYVzZYHGIU4GBU4uE98SUqUIg1say4MvcQowrQnEcbVl9glGLJy89LVRLh5TweHSjE
	m5JYWZValB9fVJqTWnyIcSIjMDwmMkuJJucDE1leSbyhsYmZkaWRmYWRibk5LYWVxHkPtFoH
	CgmkJ5akZqemFqQWwRzFxMEp1cC4cHX52pIUObee8z9Xnn3BOflxf+nyvOtKP6OONEYcuH/l
	daaycajeX13hHMdW0Ydb/HOVZttufXFwm7jOy61le77EL6pm1Nn5ofDHN7nbPNy7nru+kumI
	abiqsbiUVcrpmtrVqd82vNp77dQSu4v6B2Y/0RNf/rTMc55y9LGAHLWif1aXYvfcV2Ipzkg0
	1GIuKk4EALrKPd6IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ijlr8iH0UQ4LcZlv7Gcd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-04-03 (=EC=88=98), 12:30 +0530, P J P:
> +-- On Wed, 3 Apr 2013, Jaegeuk Kim wrote --+
> | diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> | index 47a2d7c..cf9ff5f 100644
> | --- a/fs/f2fs/data.c
> | +++ b/fs/f2fs/data.c
> | @@ -559,6 +559,10 @@ static int f2fs_write_data_pages(struct
> | address_space *mapping,
> |  	int ret;
> |  	long excess_nrtw =3D 0, desired_nrtw;
> | =20
> | +	/* deal with chardevs and other special file */
> | +	if (!mapping->a_ops->writepage)
> | +		return 0;
> | +
>=20
>   Small question, is it okay to `return 0' here?
>=20
> Earlier even if `generic_writepages' returned 0, that did not abort routi=
ne=20
> `f2fs_write_data_pages'.

I'm confusing the question because f2fs doesn't use
generic_writepages(), since f2fs_write_data_pages() is linked to
a_ops->writepages.
In do_writepages(), always f2fs_write_data_pages() is triggered instead
of generic_writepages().
Isn't it?

Thanks,

>=20
> Thank you.
> --
> Prasad J Pandit / Red Hat Security Response Team
> DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Jaegeuk Kim
Samsung

--=-ijlr8iH0UQ4LcZlv7Gcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRW+BIAAoJEEAUqH6CSFDS24QP/1Z7cyyiiJvxfwSsQS1m1A0X
EolfWjkqY7fPLVEXEier9ykMunwp5ZBh0odbjJp6ngmg5ztDN7OKPA2tIiln9Ypn
47vLJgQA0ofSZuA3uecOO1uMnXw8HLln9bEvpNOhTte7s9KlSbLmudPiVbFCaLzF
+c8pg3LCj5GUquvk7rAvtHn4s/VVsY47U73pMdZl1leNX38RlZ4OnTV8cmlHsDsk
02HO84adHlQTi9u0ZIFxBgehC+QVRw20/nNxHYpAy+Zd7k9YNaabv7wIY+GDWPFc
EQPebF8HhTzwdXibvPyOREkSHZbGz5EwwA8Hz5ENZuU5I+WFSKpGl0MWuUy6cBOw
ln5/NB0dKHFeuU0l4qw6RJeUcr9zmuEF1hjlW2+FVqA7xesqYwgJ/AMwYvSD4mI/
Op27NRNSyQFcgucnFFdU9BPWcJrtbUtkbC6UPXtaY3XvwRPNsNdGDr4AAdEgjFbw
PzXTolmheIbd5rBS76UYcVplHb+fKRyUEP3glQu0rs1gQkTbYhi3ZMw7jm71fP4g
ofHQCDEV3Z8GBVNl31adM0R/FOgsQBDeAq/nxyGuYa4ABuemfQm4v7JCkLB6ez5p
soR5/dqUP+peeVK7SimECNFqJZ74abgWSi8oDb3bVIBB35+2mXNf1ZE3DYjoRFFx
vGl0Sh7prOzcxmW0HY81
=BM5W
-----END PGP SIGNATURE-----

--=-ijlr8iH0UQ4LcZlv7Gcd--

