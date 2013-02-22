Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3BVAug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 19:50:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41716 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab3BVAuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 19:50:32 -0500
Date: Fri, 22 Feb 2013 11:50:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Yan Burman <yanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Message-Id: <20130222115021.d61d6101d1531f8dd4b581de@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/ulp/ipoib/ipoib_ethtool.c between commit 7826d43f2db4
("ethtool: fix drvinfo strings set in drivers") from the  tree and commit
4b48680b5572 ("IPoIB: Add version and firmware info to ethtool
reporting") from the infiniband tree.

I fixed it up (using the latter version as it included the change to use
strlcpy) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJsDNAAoJEECxmPOUX5FEACYP/RRPtGKSumNo17bMH1UnF6Kv
qs0jvTUjtMSTubS9RgSGg27yDmEAYuCCIz2lVCmVUHr7K5QrNQchs/OeIOK4jjIb
Svmd7qYVxmeJJNn+8YhZ1WYqDH4pzAoaActMPrKM7YPoTS1POQmbyWwY1+tPkkP5
LrMe8FHyM+pX3M7cfcd6WuGxKX4LReCjQXNr8t9iajUltdrKv0m+CeMxe5A0m/CJ
kWjvaGejEPXBUabHrB+rg2VEDmshW6ZAuV8HAKidImGpjNAMpLfnEKZAX7nSU09+
iaRcSmYTyoihru8GrCxuXGN3EC8R3J5VniDORLqg5fU84wZd0cAjULmlFPO5EOB1
qK3tMoLfF7/NpngLlbasv9gwtkiGE5c1DB7KK/PWXwwzlKVskfxdCbDzQXBjLQk0
HZQNXK6XNI0Q+u2D40pqSBc406YuGIMImSONSq4aD7oVDbdQq13CFkWRyLdwuh+P
hucVIDzi/3sXMCImHXUshVKHVYcSYBoGIvpEbXZq3lb6NV2QJaVSf7nPlQJ+UBnq
3oPbmjGD7MdAnTZaUC347CKiQZSuboH4dEvuUh1FMUKWMlyVhmyg3vWaMeo/6tUU
A+EZ7LsZp/vs5arSfskcE7yPd86F5dpbjldVqESjuoXlwsshqyodroV/61p8n+pe
VMMC2rjISyvrcYGT2mxp
=zhpp
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu--
