Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaI3KPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:15:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52644 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaI3KPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:15:50 -0400
Message-ID: <542A82C6.7090607@ti.com>
Date: Tue, 30 Sep 2014 13:15:34 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Behan Webster <behanw@converseincode.com>, <plagnioj@jcrosoft.com>
CC: <daniel.vetter@ffwll.ch>, <geert@linux-m68k.org>,
        <laurent.pinchart@ideasonboard.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <robdclark@gmail.com>
Subject: Re: [PATCH 0/2] LLVMLinux: Patches to enable the kernel to be compiled
 with clang/LLVM
References: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="mvQ6K9J0owKcKksVvhS8puOJnSImu0b97"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mvQ6K9J0owKcKksVvhS8puOJnSImu0b97
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 27/09/14 04:10, Behan Webster wrote:
> Replace the use of nested functions where a normal function will suffic=
e.
>=20
> Nested functions are not liked by upstream kernel developers in general=
=2E Their
> use breaks the use of clang as a compiler, and doesn't make the code an=
y
> better.
>=20
> This code now works for both gcc and clang.
>=20
> The LLVMLinux project aims to fully build the Linux kernel using both g=
cc and
> clang (the C front end for the LLVM compiler infrastructure project).=20
>=20
> Behan Webster (2):
>   arm, fbdev, omap2, LLVMLinux: Remove nested function from omap2 dss
>   arm, fbdev, omap2, LLVMLinux: Remove nested function from omapfb
>=20
>  drivers/video/fbdev/omap2/dss/dispc-compat.c   |  9 +++++----
>  drivers/video/fbdev/omap2/dss/manager-sysfs.c  | 16 +++++++++-------
>  drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 14 +++++++-------
>  3 files changed, 21 insertions(+), 18 deletions(-)
>=20

I have to say I do like small helper funcs as nested functions, as they
are restricted inside the parent function's scope. But, of course,
nested funcs have their issues.

So looks fine to me, queuing for 3.18.

 Tomi



--mvQ6K9J0owKcKksVvhS8puOJnSImu0b97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKoLGAAoJEPo9qoy8lh717FMQAKzuxDGrxHRLc9oBBOVmS/Xv
WYPWzczjdD1HKcnWR1D9HO+Np7C9U4hZMQRrf+6ZlJcULbmoofreXbgwmiMaT7f/
TRt8kBskR+nZS98MLF8q2wqHjyok7XsUDaNvp03FSzzCCtg7UC1rA9+j2+F8Q0YH
/kTDK7d0e9wHi/WRZ3TUCMsyDEbH/ZxQnR/IGXXu1edy78kOPxwnl6kik2SmaQlx
fZ6z2EAzR2MTVNWQrZmjxaFPuPALN5TBGBQQcqPIJ4pBBIV3PpBQPb3HLPMVm4cp
lam5y/qdCJdCNPP6k18ApCd3SOSFnZGRWXbj/4FFugPnh4PQIJCoFNPyEUQ/SDMF
+a32CT/oB+zr2pt6RGCS2P8mk1d+BUMrnZqyCDNqnqusiy1ZUdL7Llc+CDzjHX4u
2t1ipuwGOQPNkGppENj9nL4bFZdaN+VbtWIxsWtRQchvAh2pwEPWhyUmA91gjSi2
8AFSImnVArMf/66EChG04s2BHqi/sUB1chLC+Qz9UTzRpy4gVYVaUrwvBA14wMB1
o7bxVKpZaUZe+vFXDfOOkS1RlorSowxL3Ous1JFfq+flWpxXOZ8PzywI78lnyg1l
0WRsBICfD0P+rE/eLqGPXovEtFweudpi2eT7La6uloRBuAdBVyrAE9zw2e20UsYG
i24+XyRCuEZg3EtuR/jG
=KATX
-----END PGP SIGNATURE-----

--mvQ6K9J0owKcKksVvhS8puOJnSImu0b97--
