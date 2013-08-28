Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3H1BoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:44:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:34543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3H1BoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,972,1367996400"; 
   d="asc'?scan'208";a="392993824"
Message-ID: <1377654240.2005.32.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH net-next] drivers:net: Convert
 dma_alloc_coherent(...__GFP_ZERO) to dma_zalloc_coherent
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, b43-dev@lists.infradead.org
Date: Tue, 27 Aug 2013 18:44:00 -0700
In-Reply-To: <1377582323.2658.10.camel@joe-AO722>
References: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
	 <1377582323.2658.10.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jPSgA1IDszhL35Gx/tNY"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jPSgA1IDszhL35Gx/tNY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-08-26 at 22:45 -0700, Joe Perches wrote:
> __GFP_ZERO is an uncommon flag and perhaps is better
> not used.  static inline dma_zalloc_coherent exists
> so convert the uses of dma_alloc_coherent with __GFP_ZERO
> to the more common kernel style with zalloc.
>=20
> Remove memset from the static inline dma_zalloc_coherent
> and add just one use of __GFP_ZERO instead.
>=20
> Trivially reduces the size of the existing uses of
> dma_zalloc_coherent.
>=20
> Realign arguments as appropriate.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-jPSgA1IDszhL35Gx/tNY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCgAGBQJSHVXgAAoJEOVv75VaS+3OJX0P/2XAG1De7Ww5ZdnAr8htbWL3
hPZVRHb0WU2/dIVZsKkm7Hv60WekXyn4J6RKRCIC5bV4fGKGVKgmDLZdfZd6vdO5
s25OKARj1PSyrAJafCAIs6o5h1wUgNcKokA4RVmyrRzNXE2ZoHB7mqSm7JTpGxoa
EDB62VdrxjynOuGqX/HvgU9+t2g/vwwIUuKEB0UxN2aC/IgqE7dHmlffCCNChkI4
i/Njhvk/VzBA0qFuzmTEey3o/q0SZ6akiotZpnPJ2IN2UA1r2o5AATOZ7cJ9sVfZ
VJvPAUKN3tBu0xvA+YxeTtW7W8ujtKM2wCW5a8Bf9vB1sRBIOe7db8LL2EO7AJoY
4EMpxMJVlPoBkKdpzRIkiQlMWn6Anf2eyzfFOajSxozZgNLs6aqXCjEeHWouhFMP
oczQT/lUhqmgN+U5T+8QutXRkATThJ8UzlInG6zoafU04+oLmAVoXXVmE54XFjtl
K0vrzn0xGONYUZdjhpUsEGjrwMAiNf9VMd3pQjy6hyQsXnKrRedLLFKPbeQJSc3G
fYK53VkFrPKvf4k0UYzQdxq4/EHEkeQWDCqYBNYQXylWhH589bGBvPTnmsCEC4Yo
gIeeSQBfC6E7J/XY0YPCU+81wJCeaUPU9ziukUhyUrk081ycaZNbnJI6mztLi2L6
ZXKsBvT1fq6r+TOlV+LK
=UcmZ
-----END PGP SIGNATURE-----

--=-jPSgA1IDszhL35Gx/tNY--

