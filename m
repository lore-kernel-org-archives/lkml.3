Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaCLUyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:54:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:25978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbaCLUyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,641,1389772800"; 
   d="asc'?scan'208";a="498701597"
Message-ID: <1394657423.2167.4.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next 2/9] e100: Convert uses of __constant_<foo> to
 <foo>
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 12 Mar 2014 13:50:23 -0700
In-Reply-To: <b7d59e4e50e0e90546ca66d2865d52552be1e553.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	 <b7d59e4e50e0e90546ca66d2865d52552be1e553.1394644825.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5K1HhXztbhLFDj+7PQuq"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5K1HhXztbhLFDj+7PQuq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-12 at 10:22 -0700, Joe Perches wrote:
> The use of __constant_<foo> has been unnecessary for quite awhile now.
>=20
> Make these uses consistent with the rest of the kernel.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/e100.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Joe, I will add this to my queue.

--=-5K1HhXztbhLFDj+7PQuq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTIMiPAAoJEOVv75VaS+3OhVAP/1rhk+DTQGNIff/EkGyaiAzK
Fx3q43QXoCxWYyTcZYrm+rDIvd0e7ud/Rd6BaRHTzK6mKANWK+WlJGbW1bqNa4By
qJJ12WGjkLcaM4yY4UU5mi5iox8FI7teRdOLRzLZyQ5Bu5uCbxpVNk78/ScemDFT
nB47qAveD5dSiZn1LCnY0XIF3Twy6s+i4cc7UGmXc7snwo6ai62Rk9ygFHXUPXU8
27Djsp42layAOL2vYhIEKqgt1rnu+4+raktCZebpu7TDGboA2CwiIh7RGF86CcO6
wRUTz/8I3cb6/01TWGC21LHhaDYIcRxxeHtXXE+ywcR0PmyXQi33PEBYeOlnmNBk
Pwc/1mgiUNS6PsIVa2GMa49dkaGHhh9+X3U7xIkBCOrpH2i11fO44AgzlzGwFs4t
FvUWGThp+lHVHqRo9qwM9Jxi9iMsVire1g3Ug8C9m9D4kFcGuoJTk3JOjFe9UOP0
2JiDjX+ds9iUw4ADa+xCqe+JIfdqH7LXHmijkChpIEI2OHgStraVhiE1aWQWbr4o
eQHul4+zfKpjZf5TSNT9jCJ51MxK/YYhGmOfoRxtnMuVqg1aKASf0uldp7dsNgOi
QI55royh9tWWMgRsE5+IqnsA5+gqJhQ72hgoDG5zqD0OG/hWpWZa7l5Qo8r4fMND
E1/xYClbsV+QkLjBaeOg
=X7j2
-----END PGP SIGNATURE-----

--=-5K1HhXztbhLFDj+7PQuq--

