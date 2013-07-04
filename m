Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3GDEeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:34:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59648 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3GDEeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:34:07 -0400
Date: Thu, 4 Jul 2013 14:33:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Michal Marek <mmarek@suse.cz>, Daniel Tang <dt.tangr@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the kbuild tree
Message-Id: <20130704143353.e695ca64b17705c842676870@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Jul_2013_14_33_54_+1000_G+i6BIy1htjNcN6t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Jul_2013_14_33_54_+1000_G+i6BIy1htjNcN6t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
tools/include/tools/be_byteshift.h and tools/include/tools/le_byteshift.h
between commit b35310627f39 ("tools/include: use stdint types for
user-space byteshift headers") from the kbuild tree and commit
"scripts/sortextable.c: fix building on non-Linux systems" from the
akpm tree.

As fas as I can tell, these patches do the same thing except one uses
stdint.h and the other inttypes.h.  I just dropped the akpm tree patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Jul_2013_14_33_54_+1000_G+i6BIy1htjNcN6t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR1Ps2AAoJEECxmPOUX5FE2psP/3Cioz6hc9zioxcWjEOepagY
JasyLmAYvR3XfFHf5GYobs57uJtJ1c1s3vQ9j+Ana9bFEU4PRjayVHto757lxhzS
a7ilcru7pTWB7KuFfXU4Hyz+VXCUJ+nAlMQ8SAqbnRhxrAvU7zwl5gNwP0xWRLOz
7XQC8hlM+WA7jOgLO8K8WPKTR6IqJ8brGLMGib5ZpambQyn5QPwbz9gVJnIYWN0d
Ej+opxA4VViPZt1OxCukFHH85LEM7dXbQPqIb/TrL6Ti33g+F8rDLsgg68AJbx2R
7kHCAQ8ljvMvHaLe3IDRIa9Ey4rB7HY3x5DiGUHDZhBQKuDJ6y27tGIjrFYmIS/A
/h7/mkMPXvaF1a8KXDk0a6mKg6zk9BscjNUUpemoNpDWU8i+joVOHd5T8bMkSLms
MU+Wap4Zhqth1FH/0rMyQlaMf4iaI1xTdhW5rJqoCUs7vfMRmvNgXRth2uCk6EEt
3XTUxa5QsW7F3h1Gjx3ToQNPCbct3PGxZ6ge4JmguhxzRQ2JWAAsqjhUjJb4yM8L
nmkjHcxkOH2u3wRe3Ar54xf0fgRT4syYYfYtGUxY51HT3eCojoIreywlATnFXl09
hVpjnZBaRV5KWqHQfA8lZ4e18KIF4lf0XdUQP5/uQRF49gnacuy1pUPK8Q9DQ0tx
H2OdM7Qxb3JbjyXX/N3e
=DTQV
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Jul_2013_14_33_54_+1000_G+i6BIy1htjNcN6t--
