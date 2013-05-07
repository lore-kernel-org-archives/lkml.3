Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3EGKfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:35:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59921 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3EGKfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:35:04 -0400
X-AuditID: cbfee68d-b7f016d000007930-3e-5188d8d56684
Message-id: <1367922839.16581.42.camel@kjgkr>
Subject: Re: [PATCH 4/4] f2fs: optimize build_free_nids()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>
Date: Tue, 07 May 2013 19:33:59 +0900
In-reply-to: <1367853344-28938-5-git-send-email-haicheng.li@linux.intel.com>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
 <1367853344-28938-5-git-send-email-haicheng.li@linux.intel.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-ujGAJO0sZkMGphlpYptQ"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zvu7VGx2BBo9eW1ncWFBmceZZB6PF
	pUXuFnv2nmSxuLxrDpsDq8fOWXfZPeadDPTYveAzk8fnTXIBLFFcNimpOZllqUX6dglcGR/X
	LmQumC1QcfrNQZYGxi6+LkZODgkBE4lDF18zQ9hiEhfurWfrYuTiEBJYxijxZX87G0xR/9ET
	LBCJRYwS15fNZIRwXjNK7DzYA5Th4OAV0JVo+VwI0iAsYCmxefUbRpAwm4C2xOb9BiBhIQFF
	ibf777KC2CJA1RPfzmYCGcMs0A+0bPtDsGUsAqoS25dvZwKxOQV8JDr//maC2NXLKNF5oAUs
	wS8gKnGy9RMjiM0sUCXRvrYJ6lIlid3tnewgNq+AoMSPyffArpYQ6OWQuD3jFhPEBgGJb5MP
	gR0tISArsekA1PuSEgdX3GCZwCg+C8nYWUhGQcQ1JVq3/2aHsLUlli18zQxh20qsW/ceqsZG
	YtPVBYwQtrzE9rdzmBcwsq9iFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInm3h2Mtw9YH2Ks
	AjpxIrOUaHI+MBnklcQbGpsZWZiamBobmVuaUUVYSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVAMjn5/Jocv3Or1qs//qnsxfp2d8VizpppbRmo0fXq1eHvH02PRrvUt0g3hvadds
	/Fdl/9Zb42oTa8/hy6tnSM85dv7P290x/DtNQ6+9+XnuuE3vcS/dxwffV3r//fFPd43IP76b
	Irv69B5Yzd8Ubajzg6M9dOo25ZOyXzjC5vrdlzAulbP7qMi9VYmlOCPRUIu5qDgRAHlUtkUT	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xgO7VGx2BBvuXmVncWFBmceZZB6PF
	pUXuFnv2nmSxuLxrDpsDq8fOWXfZPeadDPTYveAzk8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+naYJoSG
	uOlawDRG6PqGBMH1GBmggYR1jBkf1y5kLpgtUHH6zUGWBsYuvi5GTg4JAROJ/qMnWCBsMYkL
	99azdTFycQgJLGKUuL5sJiOE85pRYufBHqAqDg5eAV2Jls+FIA3CApYSm1e/YQQJswloS2ze
	bwASFhJQlHi7/y4riC0CVD3x7WwmkDHMAv2MEl+2P2QDSbAIqEpsX76dCcTmFPCR6Pz7mwli
	Vy+jROeBFrAEv4CoxMnWT4wgNrNAlUT72iY2iEuVJHa3d7KD2LwCghI/Jt9jmcAoOAtJ2Swk
	KYi4pkTr9t/sELa2xLKFr5khbFuJdeveQ9XYSGy6uoARwpaX2P52DvMCRvZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMGp4pn0DsZVDRaHGAU4GJV4eBVOtQcKsSaWFVfmHmJUAZrzaMPq
	C4xSLHn5ealKIrw3DnYECvGmJFZWpRblxxeV5qQWH2KcyAgMj4nMUqLJ+cAEl1cSb2hsYmZk
	aWRmYWRibk5LYSVx3oOt1oFCAumJJanZqakFqUUwRzFxcEo1MPLcfnjzt3znNofiZWKTWPon
	RT1YM3OG/Kq2Biatg0m9Sfr99hkrEuVPLt1v80DpUb6Px0TTs5Gx/7uPnlQN38HTfsPMnjds
	WlteTtsKPrU5575wXxe4stPs9QuDqa5bKrf9Dn766GXZ5cPszsomcyMezpJYv5/vgVKeB+9x
	hfKzeuHKiwKEHZRYijMSDbWYi4oTAZMxL+mUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ujGAJO0sZkMGphlpYptQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-05-06 (=EC=9B=94), 23:15 +0800, Haicheng Li:
> When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT pages.
>=20
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  fs/f2fs/node.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 1fe3fe2..3136224 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1342,6 +1342,8 @@ static void build_free_nids(struct f2fs_sb_info *sb=
i)
>  		if (nid >=3D nm_i->max_nid)
>  			nid =3D 0;
> =20
> +		if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> +			break;

Could you explain when this can happen?

IMO, this is an unnecessary condition check, since the below condition
that includes FREE_NID_PAGES already limits the number of free nids.
Thanks,

>  		if (i++ =3D=3D FREE_NID_PAGES)
>  			break;
>  	}

--=20
Jaegeuk Kim
Samsung

--=-ujGAJO0sZkMGphlpYptQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRiNiXAAoJEEAUqH6CSFDSogkP/1/YJNe2b2Tdt2EuMX53sO/7
9Goy4BrZkJV1+w15Dj/tP3TDg+kRKot58PWqUblARww3R9YF+aPl4pr401vjtAeh
JQh9iEgwfutbrlbZTRG1SapWNMYD5wQAcWUN5rfdDRRQeCu5CUdFs+VzdHoPIj0k
CPz8fpsSwthJW03Apt5pRJIntfUfRCg3GYOLjYTS809Hdhrhv2PnVx3EXRax/daU
lIqcNg9vj4JZflDlMPZf6tumTbWZCsoCKaArHfnxlJl1YlNckjZZbITdzcPhh3wk
B6aOJep5utRWVbfQ9UFPy7GfJ18VrGutt8U4JImvBgkBEdDjBs/5geqb85qTOufL
QMmULibfR3t5dEh7lJ+ePort8Pzv/Dlx6xwamaI4xIK4PMwxGLsMbOJsr1+Nka2B
d7dazH60zPBDasBr46cVEVlUyGac8EdpsENlJl5p7en4IgebmTn1TJIra5O0T9WU
/aH+j0gLkX8F8RVDWQG9EqaCymM8qGeDU5OQFxieJTSqJ++M02/RxAWwFQxT6Kem
wDU7gBaieqpl0ZNfDlGquclfCEPvrNm1DuK/8lEedS3Utr1KRKtSHEDfR+VAKzTP
UJIBmSBWUkG3ZFuqI4VSwAmHIYASgsW3Oy1CUUl9DtjMqw/D4Jw449waMAe5CW0w
iT6R9hYSv4kg/1un/dBc
=C7dS
-----END PGP SIGNATURE-----

--=-ujGAJO0sZkMGphlpYptQ--

