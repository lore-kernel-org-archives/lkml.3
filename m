Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaCXUVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:21:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:57702 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaCXUVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:21:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,722,1389772800"; 
   d="asc'?scan'208";a="505724196"
Message-ID: <1395692479.2899.2.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH net-next] intel: Remove addressof casts to same type
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux.nics@intel.com, e1000-devel <e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 24 Mar 2014 13:21:19 -0700
In-Reply-To: <1395683159.13968.60.camel@joe-AO722>
References: <1395683159.13968.60.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GivF/zph7+ij6bWng48B"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GivF/zph7+ij6bWng48B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-24 at 10:45 -0700, Joe Perches wrote:
> Using addressof then casting to the original type is pointless,
> so remove these unnecessary casts.
>=20
> Done via coccinelle script:
>=20
> $ cat typecast.cocci=20
> @@
> type T;
> T foo;
> @@
>=20
> -       (T *)&foo
> +       &foo
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_common.c   | 4 ++--

Thanks again Joe, I will add this to my queue.

--=-GivF/zph7+ij6bWng48B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTMJO/AAoJEOVv75VaS+3O6nsQAJR2TqovuyOLs/x2uSTO35Y4
0Csx45FrI7Po2T6mt2b4JKcbNpPz0f6lgA4igfwa5cJB8B2SYfiezxE7R78vpeYx
rEdjY9SWC8ipiz8RqBIh0X7zGZ/PICFbcVP1dAiClCzA0cmGo4chT7I3PNECOGme
EtKoZjji+et/njSsdqzOUc/0atV8TDDiEYxEvDUfSorDl6IjDryOXmOoR4eYZy+S
L242kbcthSny131DqKiFiOK9s8XC+TVQ1LNiWNLvGDe9i2MhgNZukQnBaLtno5Wp
KEVZsHss/3qgB5vcBPp+0zio1lxBWe1CV7SnLM6Fdggm5H/LcaT+xeRQGQHAFFPL
MUCBtVsL3KFhoWN6WKlfXZb4l0hDnZ2sAUqt9A+T0mVoziydosTmCkfDYGLunKCE
mO8QEPod1P7IAQk+qdYFLJ/eE0QdqkFMgH8xH201g8V1istHI87UIEW14cN7+wOU
WgpLZAwKDxGbBDNKr35Wd0+TsDzzbaWSh6Y7b3GZc6shFwu0anXHtUUrXYaokxFu
fs049JWzK6AZyHNW940qZxycrqVg7cS3k0dP7UAjpy9jhLJO6XRBgnomC1UvCTV0
oAzIvRvKBEGpGR8Plhlx9bKHVh7e0ElLujLIqm55Vhm9HP8LDnSINHcsR7DMJqRI
P+5rnsNJc3B0xyHdfn/7
=6q6+
-----END PGP SIGNATURE-----

--=-GivF/zph7+ij6bWng48B--

