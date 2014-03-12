Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaCLUxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:53:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:57765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaCLUxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:53:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,640,1389772800"; 
   d="asc'?scan'208";a="471182067"
Message-ID: <1394657433.2167.5.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next 3/9] igb: Convert uses of __constant_<foo> to
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
Date: Wed, 12 Mar 2014 13:50:33 -0700
In-Reply-To: <0eb4523c7e13dc35a6467332e22a24719f7d7041.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	 <0eb4523c7e13dc35a6467332e22a24719f7d7041.1394644825.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KsqZb51VKd9n7Hmn550I"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KsqZb51VKd9n7Hmn550I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-12 at 10:22 -0700, Joe Perches wrote:
> The use of __constant_<foo> has been unnecessary for quite awhile now.
>=20
> Make these uses consistent with the rest of the kernel.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Thanks Joe, I will add this to my queue.

--=-KsqZb51VKd9n7Hmn550I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTIMiZAAoJEOVv75VaS+3ON54P/3XiDbOsOys6zkoLOefNIyBR
Ix4G5ArXFhe4FNkXGuqrcF0b9XL/SOYSCxIVvv4ELuMTcra12e/W8u4ZDLv9/oJE
+/mnDdKsEh9npric4ZIrPoJHjXQ/G389x7wt6Nmjzkhdn4KRrFBzx9LtwZ3Boc25
gHTwB7rv/4CyjvHZOBu2Cg7zuWXomc4EbwrTLoTSseFh2IoJjtkFfO5U8p2soRBv
mXkHD3uSZQEvj+dIzrDLXcHFOzxTUL9dNx0n4p2ERjRgKNKWkt1trCYTP5av5sab
FC2cqhfpOyUILTGF1CXkaww9IOc5SBzS7+w4uO2L7+WoAIebeX6wdKyllhEv8b8s
c7I/hA/Z9eS8O5qSLgRQH/xrdLo3droEGda0esMsPOrYQfzLEL3tjETedk5sjUyQ
LsYjYA2ONmO4McwTjoMHwQYzdLdJWDqUJuwlzLx6da3adQCV+/xjs9spdUJpf2u5
2jlT4wO3JKl1+L8NclYxnZWy99dVdWN0mH21ih5WMck7Pj2q/OC4Z6YpkgmGtZNP
OwMzv/y3ZgbqS87KVuyIO/ZDzM6fvb1iL2R0Xxw1j1mxhJud3hjLBfab3l/IjKUf
ComnXrAiJEVdd5E07tkQ8JiipMZ9ZyinpbKfE4MsUyRRBaOVxTq9PrAPm/N86lMO
JuJ/DkScmpClLrH84wsF
=REfh
-----END PGP SIGNATURE-----

--=-KsqZb51VKd9n7Hmn550I--

