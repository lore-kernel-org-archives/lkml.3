Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3HaCMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 22:12:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:23022 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3HaCMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 22:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,996,1367996400"; 
   d="asc'?scan'208";a="389124183"
Message-ID: <1377915130.2030.39.camel@jtkirshe-mobl>
Subject: Re: [PATCH 0/4] i40e: Neatening and object size reductions
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 19:12:10 -0700
In-Reply-To: <cover.1377903831.git.joe@perches.com>
References: <cover.1377903831.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-R4gStmPOyFlrWktE4Wco"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R4gStmPOyFlrWktE4Wco
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-08-30 at 16:06 -0700, Joe Perches wrote:
> Just some potential cleanings...
>=20
> Joe Perches (4):
>   i40e: Whitespace cleaning
>   i40e: Add and use pf_<level>
>   i40e: pf_<level> remove "%s: " ... __func__
>   i40e: Convert pf_<level> macros to functions

Thanks Joe, I will add these to my queue.

--=-R4gStmPOyFlrWktE4Wco
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCgAGBQJSIVD6AAoJEOVv75VaS+3OKxQP/RAcDOeW/FBvLU+6JNSTri59
MpESVelGQUOsUzhzWxYoPJkpfWUlZEH+o+NCrs9zq9E5eon9qUPN9XPROKbbyvZU
wj4SU0tOfRih4EwE3VkdJiUCksWc7VVby0gXaz1FAWzRtIfPDwh3u2mDRPvZxL4J
Ats5g7QJAaUJ1szRezdcXC4SHfWXNZciEfCL/soxmLajhN7fmPw5S7QqdaOKLuEU
+/k1PNGasaKZSUvN96UDj5b92BaLJsC99Fs9HIsnjAt+t9WpZPN1QdWz/cdnwPRr
0s5L8552nTtytXJKK1hZU0oIWJICSfkTNfClVbX1HRoM9qy0ABSlQDpe7Dh+PnWL
ToIlWWMJtWinWIwANXss+C+T2AfzSVXoGktTTdVFPEJBsSPcai7/xTSG4VOVFBHo
6ypyZ2zo8KghxjEwV5bGiCi26fcenzcn9tbwygOFRwg7X2yY64K8sdPEWHMfFzdH
JyWcIYdpRBJ8FXfJxyi8m3eZhZceq9tMwWMoNNpJzTlq+pRscRIJOTl6CY/snUdN
FT3KW0xjNG+kVLcPEM/bejauqzfrm74V7RVn1HjJkDnyEU4jD8j7DxX9NiYtfzOT
QNu7QuQeqUovQi+qmiwnhgbIiajQBhXxikgkw+i63NtKx2GvsPuZ5F06f87gn3lu
LQ7+0zlWzkGuggiBYJBc
=S0Fm
-----END PGP SIGNATURE-----

--=-R4gStmPOyFlrWktE4Wco--

