Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab3CHCdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:33:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36169 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab3CHCdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:33:45 -0500
X-AuditID: cbfee690-b7f6b6d000004563-2d-51394e07bcb4
Message-id: <1362709985.14386.33.camel@kjgkr>
Subject: Re: [PATCH 3/5] f2fs: move f2fs_balance_fs to correct place in unlink
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Fri, 08 Mar 2013 11:33:05 +0900
In-reply-to: <CAKYAXd9DDoUyB-kvumojKJQ6kR2rn+Wx+8Z4WjM1tVs10f40zg@mail.gmail.com>
References: <1362195663-20751-1-git-send-email-linkinjeon@gmail.com>
 <1362285251.14386.10.camel@kjgkr>
 <CAKYAXd9DDoUyB-kvumojKJQ6kR2rn+Wx+8Z4WjM1tVs10f40zg@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-4gOh8vieaijgVe3flwTw"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zvi67n2WgwdYLqhYXd6daXL97i9ni
	0iJ3iz17T7JYXN41h83ix/R6BzaPnbPusnvsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/Tt
	ErgyHt5qYi+4LFfRMWc2SwPjZckuRk4OCQETib+ff7FB2GISF+6tB7K5OIQEljFKvP07gwmm
	aNHs7VCJ6YwSl189ZIFwXjNKvLhzm7GLkYODV0BX4vRGLZAGYQE/ia3fH7CBhNkEtCU27zcA
	CQsJKEq83X+XFSQsIqAmMeFZKsgUZoFdjBLHji5hAalhEVCVeHH2ADNIDadAsMTUM7wQm9Yz
	SvzZdxKshl9AVOJk6yewrcwCVRJTZgpBnKkksbu9kx3E5hUQlPgx+R7YlRICUzkk/t16yQox
	X0Di2+RDLCC9EgKyEptAVoH0SkocXHGDZQKj+CyEqbOQTAKxmQU0JVq3/2aHsLUlli18zQxh
	20qsW/ceqsZGYtPVBYwQtrzE9rdzmBcwsq9iFE0tSC4oTkovMtErTswtLs1L10vOz93ECInn
	CTsY7x2wPsRYBXThRGYp0eR8YDrIK4k3NDY2MTMxNTG3NDU3pYqwkjiv/CWZQCGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2Mrqpd16+vWN0ot7K/UMaiT9+vQDuK3V1IYZZy2Gud64F8gmYP
	ioQvPzwZ+JRja4WblbVvTr2aHaPtp5v32j2Cb3+U4Tecrhf8VcUpffOajv2J7OwlS73v6G2y
	tlQ6ucMttfd+RLps5wT2LQFdGdMeH7DValnVfpAxVrOAv6P9a+rBLoYKDSWW4oxEQy3mouJE
	ACtxt7QUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e+xoC67n2WgwczF8hYXd6daXL97i9ni
	0iJ3iz17T7JYXN41h83ix/R6BzaPnbPusnvsXvCZyaNvyypGj8+b5AJYohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAVisplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMx7eamIvuCxX0TFnNksD42XJLkZODgkBE4lFs7ez
	QdhiEhfurQeyuTiEBKYzSlx+9ZAFwnnNKPHizm3GLkYODl4BXYnTG7VAGoQF/CS2fn/ABhJm
	E9CW2LzfACQsJKAo8Xb/XVaQsIiAmsSEZ6kgU5gFdjFKHDu6hAWkhkVAVeLF2QPMIDWcAsES
	U8/wQmxazyjxZ99JsBp+AVGJk62fwLYyC1RJTJkpBHGmksTu9k52EJtXQFDix+R7LBMYBWch
	VM1CkgGxmQU0JVq3/2aHsLUlli18zQxh20qsW/ceqsZGYtPVBYwQtrzE9rdzmBcwsq9iFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE4Wz6R3MK5qsDjEKMDBqMTDW7HJIlCINbGsuDL3EKMK
	0JxHG1ZfYJRiycvPS1US4f0tYxkoxJuSWFmVWpQfX1Sak1p8iHEiIzAwJjJLiSbnA1NcXkm8
	obGJmZGlkZmFkYm5OS2FlcR5GU89CRASSE8sSc1OTS1ILYI5iomDU6qBse/B4Se6x/3MmIpn
	+92WnaJzMfSE++fLuVcs4kKk+dN+Pgn7w9DLseIGr1/jysnbuHMCOs6XzOl+ldAS5ejIcCOX
	NSkmYdrZrYzX//jOviv0KYD1Fs8sa530+ztLzEqjDzvdeP9ZY49p5sctWzrqWnu/cEicmlU7
	45CFT+Qvz86Y7+9PtS8vU2Ipzkg01GIuKk4EANBwC96VAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4gOh8vieaijgVe3flwTw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-04 (=EC=9B=94), 15:10 +0900, Namjae Jeon:
> 2013/3/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > 2013-03-02 (=ED=86=A0), 12:41 +0900, Namjae Jeon:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> Actual dirty of pages will occur in f2fs_delete_entry so move the
> >> f2fs_balance_fs just before deletion.
> >>
> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> >> ---
> >>  fs/f2fs/namei.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> >> index 1a49b88..eaa86f5 100644
> >> --- a/fs/f2fs/namei.c
> >> +++ b/fs/f2fs/namei.c
> >> @@ -223,8 +223,6 @@ static int f2fs_unlink(struct inode *dir, struct
> >> dentry *dentry)
> >>  	struct page *page;
> >>  	int err =3D -ENOENT;
> >>
> >> -	f2fs_balance_fs(sbi);
> >> -
> >>  	de =3D f2fs_find_entry(dir, &dentry->d_name, &page);
> >>  	if (!de)
> >>  		goto fail;
> >> @@ -236,6 +234,8 @@ static int f2fs_unlink(struct inode *dir, struct
> >> dentry *dentry)
> >>  		goto fail;
> >>  	}
> >>
> >> +	f2fs_balance_fs(sbi);
> >> +
> >
> > I think we don't need to do this because of no issues on performance an=
d
> > reliability.
> > In addition, it would be better to call f2fs_balance_fs without any
> > dentry page.
> Regarding moving =E2=80=9Cf2fs_balance_fs=E2=80=9D in unlink part=E2=80=
=93 we considered one scenario.
> Suppose =E2=80=93 when the disk is full and it really needed to trigger t=
he
> Garbage collection. But in this we considered one scenario. Let=E2=80=99s=
 say
> the =E2=80=98name=E2=80=99 being passed is for invalid file i.e., the fil=
e does not
> exist. So, primarily in this case =E2=80=93 I think it should return
> immediately.
> In such cases it actually results in wrong timing results for the
> non-existence files.
> For this observation we thought that f2fs_balance_fs be instead called
> at a proper place i.e., after there is no lookup-failure.

If so, could you check all the locations of f2fs_balance_fs and write
one patch for whole things?
I suspect that many directory operations are exposed to this issue.
Thanks,

>=20
> Let me know your opinion.
> Thanks.
> >
> >>  	f2fs_delete_entry(de, page, inode);
> >>
> >>  	/* In order to evict this inode,  we set it dirty */
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

--=-4gOh8vieaijgVe3flwTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJROU3hAAoJEEAUqH6CSFDSJLoP/24BIHg+LvfK6Ay7f+sWX6j5
fF+67rr2BgsMjQ89nicXw55aMm56T0lgDhohaSMoJBqx14pwjLSzjmwy5JE0mJuu
bL/9cJPN/vSIyueQnH5B5QMOTLcM0QpMk0eRwjMKO/oDqsDRr6ZTI8GJE2KAJxID
Tpdo/71yFiZ7eJpRnlO9+v3AqZg5lP/XAlMgK4YtfE18DtR2Mor5gv1kMblAiEcX
Ny0YGKh/HKS8MZjnP1Qv5OSd26EUpmG9BRlOggGX6P72LTL5aNJqNiUkD7b6v4Ei
hVdqm6l6XF1AQyPYVv9WB96tGKrlFXVu4rccNIFYEcmZGxdrlK3t43+H2QbrxwXM
SkDxWMBjwuUKnIp1hw0BlpQO1Ex0Y/kXF1Bbj5y7of9cW/O6EIy31f27omW4e48/
ILv+8ouJziDNHLsh/sFmhyi47+o9iAe3+qL13cinZw+MjMvaHmLczoLWwWbV8ly7
UFihF0ldDkR8wghh5h8EPQuROIRZWBQGgKXzCCAwF4RvnhGyHDUEmaZMstV2wYFr
t8z8QwQzz6+3OvWR9nC1MnqW1/VVcDlu+3+u1tNi7QN3jiKboRGoe576CcW5b34j
Akj+l073MQTBHYjKfO7ikMOEFBlFvmK5Ksk103W/anNj9ZSAWtOfQ2I1lCof1XI/
53ImqE8BW3A091pFJ/yW
=cvrp
-----END PGP SIGNATURE-----

--=-4gOh8vieaijgVe3flwTw--

