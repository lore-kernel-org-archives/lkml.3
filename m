Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3AUA6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:58:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3AUA6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:58:21 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-36-50fc92ab96a0
Message-id: <1358729895.8234.147.camel@kjgkr>
Subject: Re: [bug report] f2fs: off by one in garbage collection functions
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Mon, 21 Jan 2013 09:58:15 +0900
In-reply-to: <20130118132949.GA5708@elgon.mountain>
References: <20130118132949.GA5708@elgon.mountain>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-FPfzcPGP4HKcFM9q9Nb0"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t8zQ901k/4EGJxcw2hxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyjnbsYC/4IVIx59NptgbGLsEuRg4OCQETiaa+xC5GTiBTTOLC
	vfVsXYxcHEICyxglVrz/wAqRMJHY9ewQK0RiOqPE9IVn2SGcHiaJWc2r2ECqeAV0JWZsuc0I
	YgsLeEmsv9fPBrKBTUBbYvN+A5CwkICixNv9d8GGigjoSFzu/MEOYjMLeEg0dnwHi7MIqEqc
	ndfOAtLKKWAs8fNKCESrkcTOtV1gJfwCohInWz8xQrRWSfxtaWKHuFNJYnd7JzvENYISPybf
	Y4GIX2KXuHTXH2K8gMS3yYdYIH6Xldh0gBmiRFLi4IobLBMYxWchmToLySSIuKZE6/bf7BC2
	tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7zAkb2VYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxghUSi9g3FVg8UhRgEORiUe3oS+PwFCrIllxZW5hxhVgOY82rD6AqMUS15+XqqSCG9F
	EFCaNyWxsiq1KD++qDQntfgQYxXQcxOZpUST84GJI68k3tDY2MTMxNTE3NLU3JQqwkrivIyn
	ngQICaQnlqRmp6YWpBbBLGfi4JRqYLQQDi/O81b8eeTpUcnDmZu/LSt8rCE8aw//d824xhaG
	4Mf9vacXeL8/sn73SVNnnumal9ZEbNx7tPf+Hg0LYcbL17WljwqfiGyZ1vNjls/T0CMeorqR
	6/7UnnJbzsjuWnuZ4WrWm2dTTrWyJH1ebxW4aHrIrND0bpFMH+OCsIyjnfpLdy7PrlViKc5I
	NNRiLipOBADG2J+0KQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQd3Vk/4EGHz4Zm5xedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM4527GAv+CFSMefTabYG
	xi7BLkZODgkBE4ldzw6xQthiEhfurWfrYuTiEBKYzigxfeFZdginh0liVvMqNpAqXgFdiRlb
	bjOC2MICXhLr7/UDxTk42AS0JTbvNwAJCwkoSrzdfxdsqIiAjsTlzh/sIDazgIdEY8d3sDiL
	gKrE2XntLCCtnALGEj+vhEC0GknsXNsFVsIvICpxsvUTI0RrlcTfliZ2iDuVJHa3d7JDXCMo
	8WPyPZYJjIKzkJTNQpKCiGtKtG7/zQ5ha0ssW/iaGcK2lVi37j1UjY3EpqsLGCFseYntb+cw
	L2BkX8UomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHOfPpHcwrmqwOMQowMGoxMOb0PcnQIg1
	say4MvcQowrQnEcbVl9glGLJy89LVRLhrQgCSvOmJFZWpRblxxeV5qQWH2KcyAgMjYnMUqLJ
	+cDklFcSb2hsYmZkaWRmYWRibk5LYSVxXsZTTwKEBNITS1KzU1MLUotgjmLi4JRqYGx6qPzV
	iD2JpeF+Tvj++t8X/Fhu3O7KtilRmXHMIVKFfZ/dlP6tXXbX9kyKqZb3smvTn+p7Oe76L+kf
	PfOev+SfnOkvlNahzfGS2f/SloaAfxst9a44LZV92y1yt3vtxp325RdUT85N3NNkfD6j+q5J
	6TrxI4fPC65kWXIjdUPqqQdsdQLTLZRYijMSDbWYi4oTAcH5j/VyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FPfzcPGP4HKcFM9q9Nb0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-01-18 (=EA=B8=88), 16:29 +0300, Dan Carpenter:
> Hello Jaegeuk Kim,
>=20
> The patch 7bc0900347e0: "f2fs: add garbage collection functions" from=20
> Nov 2, 2012, has an off-by-one bug.
>=20
>    429  block_t start_bidx_of_node(unsigned int node_ofs)
>    430  {
>    431          unsigned int indirect_blks =3D 2 * NIDS_PER_BLOCK + 4;
>    432          unsigned int bidx;
>    433 =20
>    434          if (node_ofs =3D=3D 0)
>    435                  return 0;
>    436 =20
>    437          if (node_ofs <=3D 2) {
>    438                  bidx =3D node_ofs - 1;
>    439          } else if (node_ofs <=3D indirect_blks) {
>    440                  int dec =3D (node_ofs - 4) / (NIDS_PER_BLOCK + 1)=
;
>=20
> If node_ofs =3D=3D 3 here then (node_ofs - 4) is a very high positive
> number.  We divide by 1019 and we get another still very high number but
> not so high that it is negative when cast as an int.

If the node_ofs is equal to 3, then it's a run-time bug on its caller,
gc_data_segment(), not here itself.

In gc_data_segment(),
1. check_dnode(&nofs);
2. start_bidx_of_node(nofs);

Here, it means that we don't care about indirect node pages whose node
offsets are 3, 3+1018+1, (3+1018+1)+1018+1, and so on.
(Ref. *Index Structure* in Document/filesystems/f2fs.txt)
Instead, we just check direct node pages only.

But, anyway, I'd better write comments to make it clear.
Thank you for reviewing.

--=20
Jaegeuk Kim
Samsung

--=-FPfzcPGP4HKcFM9q9Nb0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ/JKnAAoJEEAUqH6CSFDS904P/jWR/sBFhgXlNH+GpF+Mk341
1tU12ND08QmD61GCglhQkGzGNMbrcZymRmfgOY5QcINvB3Tk8tPXkZWvqi9raElB
NLFQBALBr1ohBLNXmPp3F3ElQxkhLN0xw1dL6PY8WjdQonZZPEzIfFiEyQogDvK4
13rGVvaCrdLn6u679XhNC2vdxSISI+8kI/hHQdW8oRq8TuKGcZTKz6VbdvROU+rS
pwD7k583PKAeLGYkhrr1Psak5NBs4nB1Ujd5itqPRl9hTYi+2n+cSa0vReXVWY5L
cxOvgHEcDFX6KaPwa9gkol04m6xJxyp7D6nCPf86eo5LjuE+LLLnMFLo7KkrzVuB
BQg9lkHfP9a5vbE/DoDAD/8gTH7H8ZW3eHoe2a+64HKKT6rT1Gd4VMEKqd5fySz8
FUzkZ3OW1Hl0/mSpTbqnP7H+ZihQQOCJIXvNyvlnz/wmtk5JyvOOLBuKdmvnx3fe
i9XnA82u3jt8sIWX0mKcP7F2pznp2GEhghRxurG0SFmEN/tJdM9CoqoGthtJHBR0
gCkJqQtHMaF4tXtc9sBAqzElyXpWBZw1eahMWPcjqB6hFd5/2mEf/ncXvbWimMU4
6uOwMbfYtXnoeKcq9PFyM4AAlNzj61SbvJiPnP9bYtX0Yd5BV0avwkVDQbxBpUDc
AEtbc/jlQp308eeEdtu+
=nZHP
-----END PGP SIGNATURE-----

--=-FPfzcPGP4HKcFM9q9Nb0--

