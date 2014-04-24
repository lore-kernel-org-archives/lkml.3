Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaDXCZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:25:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:17742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaDXCYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,915,1389772800"; 
   d="asc'?scan'208";a="422868685"
Message-ID: <1398306278.29638.42.camel@jtkirshe-mobl>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kubakici@wp.pl>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>
Date: Wed, 23 Apr 2014 19:24:38 -0700
In-Reply-To: <20140424114726.07876050b5b805463a085191@canb.auug.org.au>
References: <20140424114726.07876050b5b805463a085191@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WS67KpToDaxuXvbutGr2"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WS67KpToDaxuXvbutGr2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-04-24 at 11:47 +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/intel/igb/e1000_mac.c between commit c5ffe7e1f745
> ("e1000e/igb/ixgbe/i40e: fix message terminations") from the net tree
> and
> commit c75c4edfc38d ("igb: Cleanups for messaging") from the net-next
> tree.
>=20
> I fixed it up (the former was a superset of the latter) and can carry
> the
> fix as necessary (no action is required).

Huh, I thought the commit c75c4edfc38d ("igb: Cleanups for messaging")
in Dave's net-next already took into account the changes in net.  I will
take a look at your fix Stephen, thanks for letting us know.

--=-WS67KpToDaxuXvbutGr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJTWHXmAAoJEOVv75VaS+3OOesP/2phQ9lMZIO9AJRv14E92Q2w
mD3xlGl0Q3vvQBYMgp5y2j9WovzuS0bxvFwrDxDnVShHIgtZik/M9J5sVvFCNLzq
EOYU54f6fAxbXewykmkIOmvKMB8JllMop3RYZC9cQsmkKNWNxLTz3wTqEElbA8G/
gJE+jjkqerly9wWjqnzC0K5oMzdzje1Cn6+dOoib7FOG1DXcZsH5kBEhYgcidz1f
eBQo0ojqOukZsZJAo1f0Y0zjjC6RELBdHEqDD8j8RXzA7dhWU5lTBO6jTqklvJys
4POppOjPqiIQa6e91cl1MMRkJKmJefazvWpzBlVP3gpxfOD2I0Use0BqrdkJ+vp1
2KIlI/BhiSRfVCRrWLoUJdeWIZdh1/vSiZSR7vmFliR2Xkh53HUalfmfXmX9+y/5
GYUquTFOBiLa5otU0VCs9BLbweCuujUSth4Sba5b7bvZOF6MjHH4gMpoRsuwIOpj
ZzoYdwopp7IkMq6VatxNCD1c02RN4/KcrxV2MZwVQypyvO1lxW7lpssPbTJLd0Uq
X3Nfry0Zn2qst8Dz7jJRTnu4UZGZsaIxDiFa20rSTL7aBJPCIJhAqtoE+GinUWdW
xw4V3cELvBbgQw/cg2B6s0snBryCA4eg3vCqASx3Hzx6ZmNWDbszXG/LhxwZp2QV
fgL3PYFE2+JyUlSsIa6R
=AxYl
-----END PGP SIGNATURE-----

--=-WS67KpToDaxuXvbutGr2--

