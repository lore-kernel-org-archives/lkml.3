Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaIXUM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:12:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:10704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaIXUMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,591,1406617200"; 
   d="asc'?scan'208";a="578439297"
Message-ID: <1411589565.2298.10.camel@jtkirshe-mobl>
Subject: Re: [PATCH] ixgbe: delete one duplicate marcro definition of
 IXGBE_MAX_L2A_QUEUES
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com,
        linux.nics@intel.co, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 13:12:45 -0700
In-Reply-To: <1411210407-3185-1-git-send-email-ethan.zhao@oracle.com>
References: <1411210407-3185-1-git-send-email-ethan.zhao@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ltSqhgIXqL5EwNGZDvKE"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ltSqhgIXqL5EwNGZDvKE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-09-20 at 18:53 +0800, Ethan Zhao wrote:
> There is typo in ixgbe.h, two marcro definition of
> IXGBE_MAX_L2A_QUEUES to 4,
> delete one, clear the compiler warning.
>=20
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

I have added your patch to my queue, thanks Ethan!

--=-ltSqhgIXqL5EwNGZDvKE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUIyW9AAoJEOVv75VaS+3OMfsP/1QNGN6kIfqhr5pX8pXCw0p8
u15ochu8V7ZtRBWn6v7qTKK/b2LD3ZRX9x9Ja3bslsznHsHRHQbdzlyfE3+IZGdX
6G8+BYEThul3ePUNI7xas+s1SlfM6jWk8aSvNCatexSidDebJDbASC6js+YeULdP
gVHk7Jg4qUBsXJ3d1Of2mxOk1UZjfl0bHNbNyF9waYzAiiNABAuaa7KDk2Mt0Yga
VtnEbQZA/TA86SxGnsFnIMG+GaYq335rwftL3n9fpT32s6/FOHp7EjEvFDZncAFY
9a1zTpho7TQQs53KTensoofVG3NED41Sy+S4DzVbMFU37zuKPI9q024is7lIw+0r
9uzK84CAmYC6SSlABiow7RVoodAcd1Oavya29mjDFh+unlWEb9HsIT8ovm+2+Un7
8ZTDhuECRurYNvTnYQcTYpnvXfR1pg1X794evU9btl4B679O2QCvxxg8eaFsnsWt
gJXoXq9JRGbIMmpPJ4v1drNn1DdaTJpS347R7HFcKuEyuRATK/CUE9wZwdr+xn1C
i9tZoinFm3B8NB2+ZRhOmXSNs22quKkSqbG/n37Txbk74xVO0U/EB52NUHsbDOZf
pnFLnwgI2wq6FvYu/a+kTnheSCNjhAgzmC3KogiYU0IIpZaKMr4/8YxHNk3d+HFD
DkB6fc88HND1WzPmXGRM
=pclj
-----END PGP SIGNATURE-----

--=-ltSqhgIXqL5EwNGZDvKE--

