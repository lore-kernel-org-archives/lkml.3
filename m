Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaCLUuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:50:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:21726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaCLUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:50:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,640,1389772800"; 
   d="asc'?scan'208";a="497245984"
Message-ID: <1394657444.2167.6.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next 4/9] igbvf: Convert uses of __constant_<foo> to
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
Date: Wed, 12 Mar 2014 13:50:44 -0700
In-Reply-To: <52ad53c6822c19de67480e8b3e36201a30cab308.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	 <52ad53c6822c19de67480e8b3e36201a30cab308.1394644825.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IngQUu5MJa5qD6Vs4F/Z"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IngQUu5MJa5qD6Vs4F/Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-12 at 10:22 -0700, Joe Perches wrote:
> The use of __constant_<foo> has been unnecessary for quite awhile now.
>=20
> Make these uses consistent with the rest of the kernel.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/igbvf/netdev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Joe, I will add this to my queue.

--=-IngQUu5MJa5qD6Vs4F/Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTIMikAAoJEOVv75VaS+3O98wP/052ZM1D8yKOKs+b2iYn9e86
mAXVZup5mOOWqJZ1gwC0qoMgdomwVnmCQsaz+9lUyKQszvd6qTI7nExdPcHRr8BD
aiVkbewCGhYZQp0x1gyiimmdMdNgu0NNCBqTMVHdj3vXg3BJN8Fri6PDP7/jFbNW
b6xGdqpv7bA4w9coV9wn3JQOG128Wd+hI9xrm2+WtcqV3f9PfrGPllw5R3telm7m
KqbOUZIMrdo9vApFedvjwHLNExIsSpnDadtAfMb+dW4NiJun4+21wRs7jSUfbNsV
b4thMD27oWigPbjI2jo+VCJdCMpG5b/79d7qoipoJhVHTe2YdEb4ic70Wz/x0Ph3
xHt8n7tJTk7hKBccXdZwv8KLp6CsCswgO/C4tkQenK/XAz2VriACGwiVukPnhRfw
U1D/K8b23NcsGEmfU4IJG0pXj3FCvgRZTQlHySsYArOG8w6JCllQx9jIYtbuD47M
lQIH6iR3Qb2mCw6adT/ceWejoPvB4cD3GDiLvmwFyHOdfjCxctjcCCzRw/2/you2
jMimtO/URP+CL7VK9MJYuENpEe7lyyF8Q9LcV+D0HJ6m1vr+ft0UvvJbz1KXSlM+
GG+1Quhu5Bt/BVE/5k7Zqqp0YZeIRENOtjgQUrhkBD/5Rpp1IbNUSkL0UAuueWgT
3m13UOSNlnK2i3DvrEfX
=dSjT
-----END PGP SIGNATURE-----

--=-IngQUu5MJa5qD6Vs4F/Z--

