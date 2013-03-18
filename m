Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3CRFlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:41:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32112 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3CRFlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:41:03 -0400
X-AuditID: cbfee68d-b7f786d000005188-e3-5146a8ed8f03
Message-id: <1363585219.14386.71.camel@kjgkr>
Subject: Re: [PATCH 5/5] f2fs: avoid BUG_ON from check_nid_range and update
 return path in do_read_inode
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 18 Mar 2013 14:40:19 +0900
In-reply-to: <CAKYAXd804YVAc0c3ExerXanka+VpG=b_5jizGK6_QuajxN0_GA@mail.gmail.com>
References: <1363508840-2954-1-git-send-email-linkinjeon@gmail.com>
 <1363573173.14386.70.camel@kjgkr>
 <CAKYAXd804YVAc0c3ExerXanka+VpG=b_5jizGK6_QuajxN0_GA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-oxLOQlxve3gSDHLP8gvJ"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zge7bFW6BBrOeCFhc3J1qcf3uLWaL
	S4vcLfbsPclicXnXHDaLH9PrHdg8ds66y+6xe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3
	S+DKuDjrDXvBFvmKecdTGxhnSXUxcnJICJhI/F71kQXCFpO4cG89G4gtJLCMUeL4DyuYmqkb
	24BquIDi0xkl3q+5wQ5R9JpRovF2OojNK6ArcX/PQ1YQW1ggS2LmnytANRwcbALaEpv3G0CU
	K0q83X+XFSQsIqAmMeFZKshIZoFdjBIn/84F28sioCpx/tQrRhCbUyBYom1rL9TedYwS/yc8
	AJvPLyAqcbL1E1gRs0CVxJvG5+wQhypJ7G7vZIe4R1Dix+R7YM0SAhM5JPbem8oIsUFA4tvk
	QywgV0gIyEpsOsAM0SspcXDFDZYJjOKzkIydhWQURFxTonX7b3YIW1ti2cLXzBC2rcS6de+h
	amwkNl1dwAhhy0tsfzuHeQEj+ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkIju3cF4+4D1
	IcYqoBMnMkuJJucDE0JeSbyhsZmRhamJqbGRuaUZVYSVxHnVWqwDhQTSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTDGW30/N3thXfQsE7b93Ubd2y+fal8z0ZZL56Fv/Lr7ZatPPP8T6Bi6LXcy
	V1b3kU2fHh4IvxWwgUdotZBX87X9P8xFpmQZahqF+Sv9Tb1jrb3U+mBp89fFpZdmJ6/ZsSMu
	ahnDlyRbk3u2T/l1L7Oc7ypJFw4Ln3kk0tB0lnjUkRnLe6W/bI1VYinOSDTUYi4qTgQA3UYZ
	eBUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e+xoO7bFW6BBlvXcltc3J1qcf3uLWaL
	S4vcLfbsPclicXnXHDaLH9PrHdg8ds66y+6xe8FnJo++LasYPT5vkgtgiWpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWq2kUJaYUwoUCkgsLlbS
	t8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLg46w17wRb5innHUxsYZ0l1MXJySAiYSEzd2MYC
	YYtJXLi3nq2LkYtDSGA6o8T7NTfYQRJCAq8ZJRpvp4PYvAK6Evf3PGQFsYUFsiRm/rkCVMPB
	wSagLbF5vwFEuaLE2/13WUHCIgJqEhOepYKMZBbYxShx8u9cNpAaFgFVifOnXjGC2JwCwRJt
	W3tZIPauY5T4P+EB2Hx+AVGJk62fwIqYBaok3jQ+Z4c4VElid3snO8Q9ghI/Jt9jmcAoOAtJ
	2SwkKYi4pkTr9t/sELa2xLKFr5khbFuJdeveQ9XYSGy6uoARwpaX2P52DvMCRvZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMEJ45n0DsZVDRaHGAU4GJV4eA14XAOFWBPLiitzDzGqAM15
	tGH1BUYplrz8vFQlEd6GELdAId6UxMqq1KL8+KLSnNTiQ4wTGYHhMZFZSjQ5H5jm8kriDY1N
	zIwsjcwsjEzMzWkprCTOe7DVOlBIID2xJDU7NbUgtQjmKCYOTqkGRrXa75/t3N78Sm0U1pwv
	GrT2K4f6ssKtG7nueOkH5bRJLFfm/cHL9KSrRNbs2/wrzcwLjy5yMbRR1fnxiZ0l4+XjyWZ7
	E58yMilwbYjd83FuY8L1WYdUrMReCziEiuin3Hgrxev+3WX3r4s7Jn1nvTxz33IX6UWvu5pU
	bzj3v2VZduf90sTXj5VYijMSDbWYi4oTAT78+82XAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oxLOQlxve3gSDHLP8gvJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-18 (=EC=9B=94), 14:23 +0900, Namjae Jeon:
> 2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > 2013-03-17 (=EC=9D=BC), 17:27 +0900, Namjae Jeon:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> In function check_nid_range, there is no need to trigger BUG_ON and ma=
ke
> >> kernel stop.
> >> Instead it could just check and indicate the inode number to be EINVAL=
.
> >> Update the return path in do_read_inode to use the return from
> >> check_nid_range.
> >>
> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> >> ---
> >>  fs/f2fs/f2fs.h  |    6 ++++--
> >>  fs/f2fs/inode.c |    6 +++++-
> >>  2 files changed, 9 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> >> index be7ae70..1dae921 100644
> >> --- a/fs/f2fs/f2fs.h
> >> +++ b/fs/f2fs/f2fs.h
> >> @@ -515,9 +515,11 @@ static inline void mutex_unlock_op(struct
> >> f2fs_sb_info *sbi, enum lock_type t)
> >>  /*
> >>   * Check whether the given nid is within node id range.
> >>   */
> >> -static inline void check_nid_range(struct f2fs_sb_info *sbi, nid_t ni=
d)
> >> +static inline int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid=
)
> >>  {
> >> -	BUG_ON((nid >=3D NM_I(sbi)->max_nid));
> >> +	if (nid >=3D NM_I(sbi)->max_nid)
> >> +		return -EINVAL;
> >> +	return 0;
> >
> Hi Jaegeuk.
> > At this moment, I'd like to apply this patch and remain BUG_ON together
> > since we should find real bugs in f2fs.
> > How do you think?
> Instead of BUG_ON, we can make use of WARN_ON as that can also solve
> our purpose of finding the real bugs with the same information (back
> trace) and will also keep system running.
>=20

Got it~!
Thanks,

> Thanks :)
> >
> >>  }
> >>
> >>  #define F2FS_DEFAULT_ALLOCATED_BLOCKS	1
> >> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> >> index ddae412..6d82020 100644
> >> --- a/fs/f2fs/inode.c
> >> +++ b/fs/f2fs/inode.c
> >> @@ -44,7 +44,11 @@ static int do_read_inode(struct inode *inode)
> >>  	struct f2fs_inode *ri;
> >>
> >>  	/* Check if ino is within scope */
> >> -	check_nid_range(sbi, inode->i_ino);
> >> +	if (check_nid_range(sbi, inode->i_ino)) {
> >> +		f2fs_msg(inode->i_sb, KERN_ERR, "bad inode number: %lu",
> >> +			 (unsigned long) inode->i_ino);
> >> +		return -EINVAL;
> >> +	}
> >>
> >>  	node_page =3D get_node_page(sbi, inode->i_ino);
> >>  	if (IS_ERR(node_page))
> >
> > --
> > Jaegeuk Kim
> > Samsung
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

--=-oxLOQlxve3gSDHLP8gvJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRRqjDAAoJEEAUqH6CSFDSzxgP/jgzmF3mhQTKINhH16uaXPlQ
Tl9zW5vPxgxsqW7GkeTAM4m+atDRbyNWu+JENiR0n2wzFnys43yCMeT4UWrrdWFv
Pk1KQorDkWGOU0LA6P3b/s87WJFwofEa9lO6Ux+wA/abc3KSlZqK9NXyGXJd0OGg
tyBzubHPpsX4hXtzF//8E6qaH5jAr8pNHXcBangQCFTyaNPHsIwuHQaguypKVkQw
3orvt2eZCDviJhRnU/3WYQQ2bjWrfMahviFDavEuiU3MtEbs1eSJASaNnuZWQiZ6
C2yuXab2FxZH+1c27lv54PaKfIwBDf8Bh4TCNrmfeirDf8R/4kp2T1sGS8f1HO2Y
MFkx0+KWxaMXgNB6wTZHZ0h3JBZ0K+B14AhB+Rz93X9bNdyOBKY3P8YdWjfn3zuY
Msdw0WzffosbF+64tmHNlLIooWCsgTR1Fk8it+a2WNQZhNqAQAWxceAHe1DU/kum
4aEbiWHCpMQUMB4rRmbi4bZPcmEU0udQgaW6/HsQTN0tcDyyYsMMB6X1HHivJEVL
Qou4QB6nbFNXR7XsiJx6chkNVSw3PFA8mkNDZyoTx0Fzf2nWv81r+kMP+MW0awAO
YFxKcktUPMC1UhSSfXXNd+IxfucCDQv6WhPwAPrL2tcxfbXfA9Hgw5MmfiF9Ibwc
PLguI++ER/b77fUjVyiP
=mw4n
-----END PGP SIGNATURE-----

--=-oxLOQlxve3gSDHLP8gvJ--

