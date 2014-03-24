Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaCXUUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:20:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:34180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbaCXUUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:20:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,722,1389772800"; 
   d="asc'?scan'208";a="479073780"
Message-ID: <1395692450.2899.1.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH net-next 3/7] intel: Remove casts of pointer to same type
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
Date: Mon, 24 Mar 2014 13:20:50 -0700
In-Reply-To: <9e1ace2dfe6b14005e66c914b4905efb3eadd18e.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
	 <9e1ace2dfe6b14005e66c914b4905efb3eadd18e.1395692043.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QwY+dusQWyT9ZYPZ4MmC"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QwY+dusQWyT9ZYPZ4MmC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-24 at 13:15 -0700, Joe Perches wrote:
> Casting a pointer to a pointer of the same type is pointless,
> so remove these unnecessary casts.
>=20
> Done via coccinelle script:
>=20
> $ cat typecast_2.cocci
> @@
> type T;
> T *foo;
> @@
>=20
> -       (T *)foo
> +       foo
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Jow, I will add this to my queue.

--=-QwY+dusQWyT9ZYPZ4MmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTMJOiAAoJEOVv75VaS+3OHV8P/AsHgNf//X41XFI/WN+D4Cgf
boai67KNcEH+Dg6VRzFtqhPr/1zCwL0rxlyAXx+syyJluyBuuiMewO8QXAI+iUw5
KYhji1fR7irNr6XNu6hciPnzQ5dm1qU0+o9K69NITJNG2ARgiPUPNLrhJTn/Qe08
ocJ98uzVGxGh0NTcIstI6dyAfdPbIGtrTt38fzR3qigeQlLauCy/3mjxH2PAv5Kq
/1T0WVXT70yTTmq/9MU6XVv35PQMOSeeGwYPwUq4y7AsffDA+ve+AVRNTERYitAJ
gvsNI1HN0TCdgrD8WOGzfNmTHlj5BRYpGtHskcMNMk9UzcwTUgwMarqUKqHVpv2t
bJ+ITXyFrCvPAFbunxACJj0z4NilQfOcPmwzPX80+mrkOncic/RqhbheCEszYZBb
Zxz3zqEsRr0MxDxBfAI8oKwGFBIHmv82RV7aRO9k0QydRU9ijZtEme7fAEPZO5Bz
Wn4SuBH89e6aAJSa8leRaTt/3JK8gdzBHD0gAcnDvUJqNBGm8W/9JALChjVUOLxO
ineInuXMZas3O0USdCx4Z9yCTsBJBy7GpBbWqvVEvQ/oGWJrLkV8YIELX0g8KlCh
Sv68GIUqb1zgzeEkRY7LNf1P7s1UJ9zNln2bq5rXPJ6/6/RxnMV38nWbvFoK2pSc
NkbSN25hbNYgynQC2WUN
=vH7x
-----END PGP SIGNATURE-----

--=-QwY+dusQWyT9ZYPZ4MmC--

