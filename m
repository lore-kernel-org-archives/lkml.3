Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3EBWZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:25:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:2648 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab3EBWZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,599,1363158000"; 
   d="asc'?scan'208";a="327957565"
Message-ID: <1367533544.5663.7.camel@jtkirshe-mobl>
Subject: Re: [PATCH][trivial] drivers/net: Fix checkpatch errors in
 intel/e1000_82575.c
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: laura.vasilescu@rosedu.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, greg@kroah.com,
        carolyn.wyborny@intel.com, anjali.singhai@intel.com
Date: Thu, 02 May 2013 15:25:44 -0700
In-Reply-To: <1367499998-7494-1-git-send-email-laura.vasilescu@rosedu.org>
References: <1367499998-7494-1-git-send-email-laura.vasilescu@rosedu.org>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0z414rB/dgTK3zptn+ZY"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0z414rB/dgTK3zptn+ZY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-05-02 at 16:06 +0300, laura.vasilescu@rosedu.org wrote:
> From: Laura Mihaela Vasilescu <laura.vasilescu@rosedu.org>
>=20
> Signed-off-by: Laura Mihaela Vasilescu <laura.vasilescu@rosedu.org>
> ---
>  drivers/net/ethernet/intel/igb/e1000_82575.c |   33
> ++++++++++++--------------
>  1 file changed, 15 insertions(+), 18 deletions(-)=20

I believe I already have a patch in my queue which corrects the
checkpatch errors, but if I do not, I will add your patch to my queue.
Thanks.

--=-0z414rB/dgTK3zptn+ZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRgufoAAoJEOVv75VaS+3OuN4P/31L+/JsuZBvXgMuW+nNFF3Q
4q6yVySkh0sS0hebD/a2ED6E4Gl/Xv7UQQ0VW4YUDiWQkWY7Zj7eH5fEQX4+pB73
2iiC9QJzj0i5pqChQkkeAGU8kz5zqnoz3PmjagkU3iFjpXC9TEBx4Uo5Be+FTIlh
BwQHQ7Fg1TVeuQzUlsnOpHfN7rwHdHk/oj9+caiC2ihUwbYupoE4sLa2aetKTRVZ
jyrP8IWkI81dxqlUWf+0gomg0xJUpYcj/JKpzocidEU6Nq5Ax2gj61nfZLdmiiAs
9W6ZsOE7zkLkhi3IufCcGE4d/nnvmrKyIGzEO23OgUl3dXdxpL9KNXXooC+tmqZq
UX5SSKMlH3Ln+xh4qlergr90K/xCAVJcCXYhsNZad7qORY8gjRPoYpKb1OJzU1xo
1BNffnhmYTUR6ZHgktdLy+g64ImpsJkXqisARVroazowSlyMllWFgCoZq8UxZjPs
rEPDvMjq8riq1tdvKRbISQI7rvVufg6lbtP1sDFX9BVNCQ5BnbcTfsHOdMOBjVSo
ju7SOKXNM0F43KPsWMWc1KiHPuIl/rVS6QuLu3hCKush+K5TKcRoh+0L66DXcBAA
Tb3nKZzE8PYIKzu/DcOTDWjZEC5LgtvEUJ0d9myy9shBXeasDC7qnRxdk8igtWJO
kycAkAzBy4RQuXXlVvU5
=15k7
-----END PGP SIGNATURE-----

--=-0z414rB/dgTK3zptn+ZY--

