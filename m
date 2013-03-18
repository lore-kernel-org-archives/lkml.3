Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3CRKN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:13:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39744 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3CRKN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:13:58 -0400
X-AuditID: cbfee68d-b7f786d000005188-3c-5146e8e461d6
Message-id: <1363601594.14386.72.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix not to allocate max_nid
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 18 Mar 2013 19:13:14 +0900
In-reply-to: <CAKYAXd92_Lxp9A3QCzwhWdctMz=AMVUwzOEqxcbRppLH5dn+hQ@mail.gmail.com>
References: <1363586028-8617-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd92_Lxp9A3QCzwhWdctMz=AMVUwzOEqxcbRppLH5dn+hQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-XmmzpoPqVqNx4ZLh3CW4"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zfd0nL9wCDVrXaFvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUsXbaLrWCJZEXXzonMDYxLRLsYOTkkBEwk5l57ygZh
	i0lcuLceyObiEBJYxiix/MReFpiiVzd3sUAkFjFKtLSvY4RwXjNKvPjeww5SxSugKzHv53Em
	EFtYwEzidNt+5i5GDg42AW2JzfsNQMJCAooSb/ffZQUJiwioSUx4lgoSZhbIlJjzejIriM0i
	oCrxZeJSsBJOgWCJtV1VEJt6GSVevXzDCFLDLyAqcbL1EyNEb5XEhY4PTBB3Kknsbu+EukZQ
	4sfke2A3SwjcY5e4vbQZaoGAxLfJh1hAFkgIyEpsOsAM0SspcXDFDZYJjOKzkIydhWQURFxT
	onX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1dwAhhy0tsfzuHeQEj+ypG0dSC5ILipPQiQ73i
	xNzi0rx0veT83E2MkJjs3cF4+4D1IcYqoBMnMkuJJucDYzqvJN7Q2MzIwtTE1NjI3NKMKsJK
	4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhlLx6OlRF6Gme+N3bbnkaWBU4c7Hs2
	hIWcCHXx9RfaKZqpbiXyW878o/6B4FVVvjvntO9uUri8Pn526dG66ysqXi/VSzYKybJ6vmrC
	uYwfb3hmXXP+d3XpnJunbXc/Y7iV9vj7PfniHZL9p/avLv6wc4vx+Qt5J96oZxu9W1vR0f+t
	aI1XhsFOJZbijERDLeai4kQAKZ7hHfYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAd0nL9wCDR5NVrXYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWLpsF1vBEsmK
	rp0TmRsYl4h2MXJySAiYSLy6uYsFwhaTuHBvPVsXIxeHkMAiRomW9nWMEM5rRokX33vYQap4
	BXQl5v08zgRiCwuYSZxu28/cxcjBwSagLbF5vwFIWEhAUeLt/rusIGERATWJCc9SQcLMApkS
	c15PZgWxWQRUJb5MXApWwikQLLG2qwpiUy+jxKuXbxhBavgFRCVOtn5ihOitkrjQ8YEJ4k4l
	id3tnVDXCEr8mHyPZQKj4CwkZbOQpCDimhKt23+zQ9jaEssWvmaGsG0l1q17D1VjI7Hp6gJG
	CFteYvvbOcwLGNlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH/DOpHYwrGywOMQpwMCrx
	8O5Y7xYoxJpYVlyZe4hRBWjOow2rLzBKseTl56UqifA63gZK86YkVlalFuXHF5XmpBYfYpzI
	CAyOicxSosn5wDSVVxJvaGxiZmRpZGZhZGJuTkthJXHeA63WgUIC6YklqdmpqQWpRTBHMXFw
	SjUw7rrgu+pDKGvaPh+3+2v+TTNLfulbqbUxi31Kx+akn2HnV+/pr9Py6T6s3z29xlj93cNV
	B5MDP+lP0kpdurZMjO8PMzND0YdJ00vMFRp3n/lQWnzc6FSy5Ou3Ewz9J+l/yi/z6lOUftv+
	qU5eKLf7QPu+v67W7j2BXdJrXk8P1+ntNC7M57ysxFKckWioxVxUnAgA8yv3/ncDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XmmzpoPqVqNx4ZLh3CW4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-18 (=EC=9B=94), 18:29 +0900, Namjae Jeon:
> 2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > The build_free_nid should not add free nids over nm_i->max_nid.
> > But, there was a hole that invalid free nid was added by the following
> > scenario.
> >
> > Let's suppose nm_i->max_nid =3D 150 and the last NAT page has 100 ~ 200=
 nids.
> >
> > build_free_nids
> >   - get_current_nat_page loads the last NAT page
> >   - scan_nat_page can add 100 ~ 200 nids
> >     -> Bug here!
> > So, when scanning an NAT page, we should check each candidate whether i=
t is
> > over max_nid or not.
> >
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/node.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index c60919f..3fb6dfe 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1270,6 +1270,8 @@ static int scan_nat_page(struct f2fs_nm_info *nm_=
i,
> >  	i =3D start_nid % NAT_ENTRY_PER_BLOCK;
> >
> >  	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
> > +		if (start_nid >=3D nm_i->max_nid)
> > +			return fcnt;
> Hi Jaegeuk.
> How about use "break;" instread of "return fcnt" ?
> I think that break is better because there is no extra condition before r=
eturn.

Ok, thanks. :)

>=20
> Thanks.
> >  		blk_addr  =3D le32_to_cpu(nat_blk->entries[i].block_addr);
> >  		BUG_ON(blk_addr =3D=3D NEW_ADDR);
> >  		if (blk_addr =3D=3D NULL_ADDR)
> > --
> > 1.8.1.3.566.gaa39828
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

--=-XmmzpoPqVqNx4ZLh3CW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRRui6AAoJEEAUqH6CSFDSWEwP/Rgv6EJctBWpxDpx54aQt6uM
kJpZGbY6/Ec/MldFvNLOoBQo9AR7zmHvaFV5b0XqIgCnl5jk+L5IMLGJKETeRar0
tmJif7/dtqe6XmH90d3QWM9nX0sYNETXL0crtsg88XH3rtHboQrZptHTVg4DZPGE
jdugDComNAtefG8qBqPfpRMJMzYTPJWRD3zEE3usK86hEiCH4MrQOZmcAfFv2SoR
XTpdRyjbaoOoFctzlwvuksKNm7iKUpOgQTOCAqKZqRaWICO1sIxW1V4dZawaVVof
jLxkjQ5/1YB3EoKDkzj9UgCs0D4nhqyk62HH0RaSb6y1MmvwLkLdF9UIAacMGGfY
maUXtS4qSfyBaeaVkyxu7c7O7zR+m8/ABOCQRpfqGUJUPnhvWZZayeV8aD9icpYV
9PXLHkZwly6tEZqhWEyeOe2b8i8DPJQZtF6xWIIlMIPJ9+MTsfL22SmtBdIdS4Cn
DC9FhPJO8oJOd61wHP/WY8o4pzrSML+CMNXIomZQdZ5lSNJSU8MZtRVMujZuz8HK
Aqoti3dZSfRxzvyDFe3XWLlLP3okkthVETtg2hxUddKw8TBpAtCZqg1POSim6dAK
L6Xyaqkfc/OZ4urkVpmyxVRgh/wQP8BxhCoE80kZDKXm8bpWo+rFqpJ1sMX7BzL3
57+9xGkmEAxMgGpur4or
=oRkl
-----END PGP SIGNATURE-----

--=-XmmzpoPqVqNx4ZLh3CW4--

