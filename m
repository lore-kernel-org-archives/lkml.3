Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab3DXJh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:37:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59863 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3DXJh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:37:27 -0400
X-AuditID: cbfee68e-b7f0d6d0000053ce-5d-5177a7c131a5
Message-id: <1366796168.31792.23.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: add REQ_META about metadata requests for submit
 bio
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 24 Apr 2013 18:36:08 +0900
In-reply-to: <CAKYAXd-YL-OwW2bRc+YS6E8_OtmKk+rC-LXzc4p6X3Veitee5A@mail.gmail.com>
References: <1366388860-18735-1-git-send-email-linkinjeon@gmail.com>
 <1366598966.31792.1.camel@kjgkr>
 <CAKYAXd_VCEdN-qfu4-yZk847hYbBi=5dtGFKYGPYJDRQ0PAkKQ@mail.gmail.com>
 <CAKYAXd-YL-OwW2bRc+YS6E8_OtmKk+rC-LXzc4p6X3Veitee5A@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-baPUF0DdroKIgk6+aeXj"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zvu7B5eWBBhvWq1pc3J1qcf3uLWaL
	S4vcLfbsPclicXnXHDaLH9PrHdg8ds66y+6xe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3
	S+DKOHP2DFNBh0DFzCXcDYyfeLsYOTkkBEwk/vSdZYewxSQu3FvP1sXIxSEksIxRYseXaUww
	RedXzWSCSCxilPj29QlU1WtGib6Hi8CqeAV0JaY9aGQFsYUFQiTu7JsDZHNwsAloS2zebwAS
	FhJQlHi7/y5YWERATWLCs1SQMcwCuxglTv6dywZSwyKgKnHy+E1GEJtTIFhiy9eNjBC7vjJK
	fD61CayIX0BU4mTrJ7AiZoEqidcT3kK9oCSxu72THeIeQYkfk++xgDRLCPRySHy4uocJYoOA
	xLfJh1hArpAQkJXYdIAZoldS4uCKGywTGMVnIRk7C8koiLimROv23+wQtrbEsoWvmSFsW4l1
	695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIVHdt4Px
	5gHrQ4xVQCdOZJYSTc4HJoW8knhDYzMjC1MTU2Mjc0szqggrifOqtVgHCgmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamDMK3txv04jRDiuku9U2b5Plf+1iydyvTix30Tbc4fefSbNVK/D7m+1
	vSfXPBIVXh766+23jTv/HFmpa933xitKxfMWzxfBO6/XqwQ+uG82j6eyRdS6OsLgAeuFh3/u
	237qcH4lo1Psbr5UtjaktZxDtzIyzcYgYJN34J70Hd77hCJfX/mozKfEUpyRaKjFXFScCABD
	/WW8FwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xgO7B5eWBBjP7FCwu7k61uH73FrPF
	pUXuFnv2nmSxuLxrDpvFj+n1DmweO2fdZffYveAzk0ffllWMHp83yQWwRDUw2mSkJqakFimk
	5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYxZpw5e4apoEOgYuYS7gbGT7xdjJwcEgImEudXzWSC
	sMUkLtxbz9bFyMUhJLCIUeLb1ydQzmtGib6Hi8CqeAV0JaY9aGQFsYUFQiTu7JsDZHNwsAlo
	S2zebwASFhJQlHi7/y5YWERATWLCs1SQMcwCuxglTv6dywZSwyKgKnHy+E1GEJtTIFhiy9eN
	jBC7vjJKfD61CayIX0BU4mTrJ7AiZoEqidcT3rJDXKoksbu9kx3iHkGJH5PvsUxgFJyFpGwW
	khREXFOidftvdghbW2LZwtfMELatxLp176FqbCQ2XV3ACGHLS2x/O4d5ASP7KkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzglPFMagfjygaLQ4wCHIxKPLwvZpUFCrEmlhVX5h5iVAGa82jD
	6guMUix5+XmpSiK8nvPLA4V4UxIrq1KL8uOLSnNSiw8xTmQEhsdEZinR5HxgossriTc0NjEz
	sjQyszAyMTenpbCSOO+BVutAIYH0xJLU7NTUgtQimKOYODilGhhjmTov782dlfVgWVCCqdjX
	SQ7mezMLHsautq3N5vCLXKvAFh7EeyLe8ZSriW//5C9/b01VW7Nh992jqcuy1WVLtDqdCoqf
	nA+MLxH4vO3oVomLL5zFrjVYlSawKVvUyS+pXW24xuqSyan3D922PzjRETiNUVv8rNh8PpbW
	ZIMJpk5O5cp+n5RYijMSDbWYi4oTARHoQE6YAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-baPUF0DdroKIgk6+aeXj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-04-24 (=EC=88=98), 15:08 +0900, Namjae Jeon:
> >>>
> >>> +	if (type =3D=3D META)
> >>
> >> Should be if (btype =3D=3D META).
> >> Thanks,
> > Yes, Right :)
> > Thanks for fixing.
> Hi. Jaegeuk.
> Should I resend the fixed patch as above your comment ?

I can handle it. :)
Thanks,

>=20
> Thanks.
> >>
> >>> +		rw |=3D REQ_META;
> >>> +
> >>>  	if (sbi->bio[btype]) {
> >>>  		struct bio_private *p =3D sbi->bio[btype]->bi_private;
> >>>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync,
> >>
> >> --
> >> Jaegeuk Kim
> >> Samsung
> >>
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

--=-baPUF0DdroKIgk6+aeXj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRd6eIAAoJEEAUqH6CSFDSvcsP/jY5ZZF57s8d0VAAmQ/mQCaz
sCzj7o0uRwv4RsUhKU4uFy6MRig39y2FUFlQKHpzOHGStKqObqjSiV6fTk4CA6gj
0S7bKuJ+ydwaswkohr3/cAJwLXWuTZ9tgIOhf8fCvY3qS5m9EoBBDGopI0NKkLcF
28wxN5ZZuNEGTdHy+1EOHpfUQZL4YuLizhlfMTMHW2BQpUHFpfMh4QQBjnuoG0ux
mmhndsV5G5MXD+YECeZolnnXVMWuVEzc2vjYDLwAuKgbqPcnB+y7ldu0qzbf5jVm
YRu/HSZXWmr03r8ZVV7yQRZoM0LMUEx68qVgNu/qGxCE5DXbn929OnbHh6PqEf3A
bly4EY83gj3oEn1Iihm9Wrt6QnHRZKkbrj/Fbub7+ZAczmwekroOPsKOuhEpn+7Z
YXaNHPlapSWnP4hLdLdFTuq3eSPJtz3rKNrMtN/OEff7ALEZrxnuBfkW9KoAfyU4
S1G6+CBOIUzfTiqU109J53sgwLAQ9H1p+vrIKDlsRgmF0297HHXJ2RHZv9UhovIm
XXgrGkPhfYsvJUe+L+HtnLNctN1+27W4eqy0miGomuB0Nd7Dv8vSnWj1z5rSAzPB
rGqMknkEx3iKD3/v+aPS7kYkuuBLhp8Z1m8m7Jic7HPpl6QRZn5hjS1XfKIgDlXE
XeWi93J2LgAESCtP/R76
=qsZZ
-----END PGP SIGNATURE-----

--=-baPUF0DdroKIgk6+aeXj--

