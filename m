Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaJ2APF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:15:05 -0400
Received: from ozlabs.org ([103.22.144.67]:47960 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaJ2APD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:15:03 -0400
Date: Wed, 29 Oct 2014 11:14:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vince Bridgers <vbridger@opensource.altera.com>,
        Viet Nga Dao <vndao@altera.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20141029111453.32165a2e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wiQZoDvmjQdL2I7LrqNiQ5q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wiQZoDvmjQdL2I7LrqNiQ5q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/phy/marvell.c between commit 99d881f993f0 ("net: phy: Add
SGMII Configuration for Marvell 88E1145 Initialization") from the net
tree and commit b02241755d0e ("net: phy: Adding SGMII support for
Marvell 88ee1145 driver") from the net-next tree.

I fixed it up (they are basically the same patch :-( so I just fixed up
the differences and basically used the net tree version) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wiQZoDvmjQdL2I7LrqNiQ5q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUDGBAAoJEMDTa8Ir7ZwVT8YP/3uMfozo5hj3ZC62a+O7hn2X
0iD9ytLL7wc+WJjlFDoNj+SRvaHb5JIaGX57ny1oboGNmO8SvhLcuVDdBNA9Sv6N
BSHwqv/H5bydQVtsJLc8YTat78ib8wugN4nPu/lkOFYRZdHbarmryDn3SjGmDjtx
SSqPzx70ghFWbyo/2vOdzJ78nKO17sJUY4lGUk8jhOyl3y3jcDrY3nnllRUUwFN1
ja7yA5tRclkIalYGW0A/9i5/rH/gN7Ug5PXfu/MadvAbNs1C3HKVAN7NvgM9LScC
Wy/mTBt8z232AUpiAK9S64Aiyy1G2m9UKAcddFb/5Y37sngNG7MaEh5AhFz7C0Kg
Qx5A9yfWVIZCNCt4I4ZpUS1pSkw4csTM56dP1Ue5N1Ptw1zkcCUpb0mA9aaBgO/v
E62oz32fuuQGVRt8wAHoIo88wJCnY3347+/2G+tRzoUbnUPXmDhLuD5C6k6+LjDH
P0ThbEA+7dEy8oZ7QIbabPDcK9hXJ0M4FWtllmB8RCgNWy2IUs5vlH1VwKxyc72y
rLxaQmKrpbhghklawJY6Jj3udzctfP5ygW6uWSdjjJEWvf/ms5ezV9uhfxklSVt3
oPzoILkuJKuwEAhojoJ3zAXMGWJskbOIbkQTXqm7JAkTy3oGVJoNWUUn9FJ5rk7Z
O6LqFvvwhGSr0Lfk2OwB
=/2Io
-----END PGP SIGNATURE-----

--Sig_/wiQZoDvmjQdL2I7LrqNiQ5q--
