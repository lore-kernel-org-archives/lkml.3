Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3CKXKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:10:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56582 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3CKXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:10:04 -0400
Date: Tue, 12 Mar 2013 10:09:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: linux-next: unneeded merge in the security tree
Message-Id: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_10_09_50_+1100_nMy5j9Vjlnf9b1Q9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_10_09_50_+1100_nMy5j9Vjlnf9b1Q9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

[James, I am not picking on you, just using your tree to illustrate a
point.]

The top commit in the security tree today is a merge of v3.9-rc2.  This
is a completely unnecessary merge as the tree before the merge was a
subset of v3.9-rc1 and so if the merge had been done using anything but
the tag, it would have just been a fast forward.  I know that this is now
deliberate behaviour on git's behalf, but isn't there some way we can
make this easier on maintainers who are just really just trying to pick a
new starting point for their trees after a release?  (at least I assume
that is what James was trying to do)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_10_09_50_+1100_nMy5j9Vjlnf9b1Q9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPmQ+AAoJEECxmPOUX5FEdmoQAKbQ3uGWE711TLg6NihAjB0N
M6QSCXsVvNGLDr56MnjujbV0IF2lr5ra1R9CzN20XzxmasCpbwI6X9BaHgtWW3m/
g+eFj/hMYTnRcSrmHqKlEUiKjZ6os9JhIOSViOiSATlETjQYMKH/anWxaPlcbYme
qW4BWeCGb6FkhgbhRxBFh6ypJxk74PHhiF/Zu24PUkZJNTsTLOMYfuG5GZYhEup6
Xd9s9NSuHAlx6/nAD3jQReP1cXLBplzIvtulbliUOsOOHJmxtSxgwpg1iT6emJB1
XKDc5kFltmesflobVzXjNed2Uxu/dYHAeWQeWjNvo/CBGA6S5y7FNk+ZjpFesb4F
uGn3pJvHgre3zz8oOl71zldAs4KWLAry3CzqcbG8Tm8+7JMfMKv2OBy/7HlpcBcB
ql02qugWTdsdZdl7mpwLfprcdfWUKw2Yn6/pysYeJboHOs4Qx+mSricYWRISwRzL
yTqhiCzhKIWrmH7ToIyzXkqT0wDQKOKMyG+hh3GiewCM3eW6G3v2onUggRhMK3We
SIN6bxrweZBzhLeLzfIhzm4w+b9zL34C+y8V4JBNwxKMc+tj5l2MLfj+Akcb/V7F
y8dix5fg4eBJReEX70pEAdFonp3AAZ4tJ30K4EMvcYR4sbrN5I5kmo0FdaiApJ0j
l63ZcvOOQXSf7v4abdta
=D8Cj
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_10_09_50_+1100_nMy5j9Vjlnf9b1Q9--
