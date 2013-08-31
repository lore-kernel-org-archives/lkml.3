Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3HaCMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 22:12:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:46252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3HaCMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 22:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,996,1367996400"; 
   d="asc'?scan'208";a="371377472"
Message-ID: <1377915156.2030.40.camel@jtkirshe-mobl>
Subject: Re: [PATCH] i40e: Fix 32 bit shift compilation warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 19:12:36 -0700
In-Reply-To: <1377913655.2070.45.camel@joe-AO722>
References: <cover.1377903831.git.joe@perches.com>
	 <daa992875a6f542adc41069daeb81246e46b7f80.1377903831.git.joe@perches.com>
	 <1377913655.2070.45.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yWD5AuySMOPFe8A/Z+ip"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yWD5AuySMOPFe8A/Z+ip
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-08-30 at 18:47 -0700, Joe Perches wrote:
> When dma_addr_t is a 32 bit value, >> 32 emits compiler warnings
> Use ((addr>>16) >>16) to avoid this.
>=20
> I presume the macro should actually use the kernel.h
> macro upper_32_bits() eventually.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_hmc.h  | 2 +-
>  drivers/net/ethernet/intel/i40e/i40e_type.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Thanks again, I will add this patch as well to my queue.

--=-yWD5AuySMOPFe8A/Z+ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCgAGBQJSIVEUAAoJEOVv75VaS+3OdKkP/AiKMeYIwZK7igp+wtZn+w7J
v965VK6eRu+SSDdZVLF/Clm6iA3he7zZUUNKbDrh1E+6X/w05/JpTPpcfPQXtWUy
STAodePK7Ui18RY1UZpyYZucROGxxuuswqZOfwCYduu3NazH7Ch8HwPVuBDv+Anz
ljXltQbkJl6AiZfjr5qZdFl2V7TuGHYi49FghCdKzj4oXz3SGtULJKGAVDO1syKY
DUdrK2fNRumnEy+GcUjsvgTBAedrU+JssHzR5Cx4x08aoTZ+TEInBKJ7X7SnFe92
Iq5ZcDZDExiKPxkXJHgXBEzFjZYu09ucBfjdNbVDfhJJiAVIUsf/m6nVNpmIw3/6
wc6JDKlT7sOODQsQ7xg26xBy0T/e8t32cOAkyiKEzYqREIbogYrVn5Z82S6R1yvg
9E5ArAn9vQs7Wfcc+g1AU8g6BKchvHWhhPfFdFw+nYpd1bG+PhdfHb3H49JhRzyO
4dhQP2xBGH4992U5ZwwFcu0PqrTqTtIiZxqrlKijiyHn1mFehKq+WOK2tAkx6Usn
p4hfHMlH89K8Q2fpPVzc4UP6ku6fLPwMAiijWGCKj/PoEuErG+CAkFx93OuEcr6s
PVg86JG4u3llZ+0L3lbRblpgxSuSisxgiWPKHNoGhCMsbaEaIV4AJRUd3aECJkvf
RqmYXxg9U7DNFtC4+RNN
=mWdb
-----END PGP SIGNATURE-----

--=-yWD5AuySMOPFe8A/Z+ip--

