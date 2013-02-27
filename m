Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab3B0BFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:05:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42291 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab3B0BFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:05:18 -0500
X-AuditID: cbfee690-b7f6b6d000004563-b6-512d5bcc661f
Message-id: <1361927080.31428.25.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: introduce readahead mode of node pages
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 27 Feb 2013 10:04:40 +0900
In-reply-to: <CAKYAXd-8cJaE8Ry1biTyM1utWs4J8gppBLadz36LMcny+W5EBA@mail.gmail.com>
References: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
 <1361857068-31613-2-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd-8cJaE8Ry1biTyM1utWs4J8gppBLadz36LMcny+W5EBA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-4Y2PaV1koSSPLJmK4IcP"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zY90z0bqBBvcvSlpcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+P11mNsBccFK9rW
	HmVvYGzl72Lk5JAQMJE40H6fDcIWk7hwbz2QzcUhJLCMUWJ3ax8rTNHZI+eZIBLTGSWmbnkE
	5bxmlHg1ZRUTSBWvgK7Ejb51YKOEBVwlHh46BWRzcLAJaEts3m8AEhYSUJR4u/8uK0hYREBN
	YsKzVJAws0CmxJzXk8HCLAKqEo2L5UDCnALBEit7rkFtOsMo0T/7Ctg9/AKiEidbPzFC9FZJ
	7JlxkxniTiWJ3e2d7BDXCEr8mHyPBSL+k13i4vRSEJtFQEDi2+RDLCC7JARkJTYdgGqVlDi4
	4gbLBEbxWUimzkIyCSKuKdG6/Tc7hK0tsWzha2YI21Zi3br3UDU2EpuuLmCEsOUltr+dw7yA
	kX0Vo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRkjcTtjBeO+A9SHGKqATJzJLiSbnA+M+ryTe
	0NjYxMzE1MTc0tTclCrCSuK88pdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwBnGf3LVt
	y4q7G2Ut7x2OXmC+48nU3dIq/+dYul1IkP4w28JU6v5dyblh/z1fr2KcstrOP3JzkOv7opyT
	C05ckxT7+nyvqLCZ/8zanb0rPyl5GkY/+rBCae0LlWe6KTN+BazJTKq2LQkz88urDZr8y/6e
	8vbNjwN/uDUfu3WB+Yd+0/IF4t/CVyixFGckGmoxFxUnAgD5xW6sCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jQd0z0bqBBvM7RSyu373FbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxeusxtoLjghVta4+yNzC28ncxcnJICJhInD1yngnCFpO4cG89WxcjF4eQ
	wHRGialbHjFBOK8ZJV5NWQVWxSugK3Gjbx0biC0s4Crx8NApIJuDg01AW2LzfgOQsJCAosTb
	/XdZQcIiAmoSE56lgoSZBTIl5ryeDBZmEVCVaFwsBxLmFAiWWNlzDWrTGUaJ/tlXWEES/AKi
	EidbPzFC9FZJ7JlxkxniTiWJ3e2d7BDXCEr8mHyPZQKj4CwkZbOQpCDimhKt23+zQ9jaEssW
	vmaGsG0l1q17D1VjI7Hp6gJGCFteYvvbOcwLGNlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgSnhWdSOxhXNlgcYhTgYFTi4V1wSSdQiDWxrLgy9xCjCtCcRxtWX2CUYsnLz0tVEuH9eAAo
	zZuSWFmVWpQfX1Sak1p8iHEiIzA4JjJLiSbnA5NZXkm8obGJmZGlkZmFkYm5OS2FlcR5GU89
	CRASSE8sSc1OTS1ILYI5iomDU6qBcfs7n16ZIzv7UnkaPgTmvXyT8ZY3o/vrjquRjPbpz23O
	9rnv2bX1b8qd/ErNrTdzpayCWtv0JXaHbv0zT0V7ipRUXt00p28bFu7Salu//cz86v/ntxir
	ze68kPDoRe/pd9lzzS+1XWueqXuoJ/dNbIy7rFEwy5s9W8L94x3cvlmcNWBl5Fw9X4mlOCPR
	UIu5qDgRAIE4VeGKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Y2PaV1koSSPLJmK4IcP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-02-26 (=ED=99=94), 20:52 +0900, Namjae Jeon:
> > @@ -434,7 +434,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgo=
ff_t
> > index, int ro)
> >  			alloc_nid_done(sbi, nids[i]);
> >  			mutex_unlock_op(sbi, NODE_NEW);
> >  			done =3D true;
> > -		} else if (ro && i =3D=3D level && level > 1) {
> > +		} else if (mode =3D=3D LOOKUP_NODE_RA && i =3D=3D level && level > 1=
) {
> >  			npage[i] =3D get_node_page_ra(parent, offset[i - 1]);
> >  			if (IS_ERR(npage[i])) {
> >  				err =3D PTR_ERR(npage[i]);
>=20
> Hi Jaegeuk.
> There is no LOOKUP_NODE usage in this patch.
> I think that we can use LOOKUP_NODE flag instead of done(bool)  like this=
.
>  if (mode =3D=3D LOOKUP_NODE)

Hi.
In order to do that, we should check additional conditions like i and
level together with mode =3D=3D LOOKUP_NODE.
So, I'm not sure how much it makes clearer by using LOOKUP_NODE
explicitly.
It seems fine to me, since we can just use LOOKUP_NODE to distinguish it
from the other modes.
Any thought?

--=20
Jaegeuk Kim
Samsung

--=-4Y2PaV1koSSPLJmK4IcP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRLVuoAAoJEEAUqH6CSFDSNY0P/2JboXSPwDNLM+vOu7PiXvOQ
c5BkZWBUdwDTN1xTLGyhWOimruGgvW/KUZdTL4pFhVVIJ3D8yT1eeeh4cF9Tgr1r
GVmVBxTb3drqLMonP7DVCJDxlhzYl9SaTLwrWDG7I2ppE3HiTq4Sci6E7il8rNlM
waW5sINRHaxS9ZsClOAbuDe1LHAp/utDQ4BwFnompy1wycv1MWT1ceF1mQoDk427
7tUIKceQ1oDDveXvPdoMw8j8+0GVD8iuY+T5cFOpuBOHtxUgD75MBK9U2kDKc2JA
NtvU22ZKGU2y34h4dR1s6WryEcOW8eCcHAbaGsq4HKR5t/A/vurr8NaccMmeP/YQ
tjx8iF7DB6RfkD1g3sfsgSzNjD7imyG9fajRArk2dttnnhx6IyqZ+1yf4RFD0mN7
05JuHAIl7XAiVuj1FSOcEx+NF9oyXIEt49dz4+lRZwpyPBik0oDa3LyTUceW1MOb
J9SjeyxK8L2ro7cvl5P5l0HU8fXp5inXhzG0gsgTXMaO/btLqwU0ks0kOV6tWOcY
sJpZfLFIsaARbAA5Zy6Chagdcli8bFW6i2xFVDtlt6eN58fQc57V04VgnHuZVi/V
qmRuJH8Mcks/+1PL8FwKKS5s6U/DpyaXjMkXSxAP32QuQuxczz/qLes94V4jqu+w
r4L0UaGO7a0K6xBGXtRc
=EscI
-----END PGP SIGNATURE-----

--=-4Y2PaV1koSSPLJmK4IcP--

