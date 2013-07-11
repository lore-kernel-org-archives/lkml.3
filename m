Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3GKAB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:01:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56950 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GKAB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:01:26 -0400
Date: Thu, 11 Jul 2013 10:01:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul.moore@hp.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rebase of lblnet tree
Message-Id: <20130711100117.8b042a1a2a494bb9ee0003fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_10_01_17_+1000_xZ8Lp2nMbq74BLmc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_10_01_17_+1000_xZ8Lp2nMbq74BLmc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Why have you just rebased the lblnet tree
(git://git.infradead.org/users/pcmoore/lblnet-2.6_next#master)?  You have
just invalidated your testing and made it likely that Linus will blast
you if you ask him to pull your tree.  Your whole tree was already based
after v3.10 (i.e. released or rebased after the merge window opened), so
why move it again?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_10_01_17_+1000_xZ8Lp2nMbq74BLmc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3fXSAAoJEECxmPOUX5FEn/MP/inTAix2KYnAPY8GMhmmz6c4
QaEeNqJY8RukEKWFNFbGw63j8nVrqSiQ4w+AEGJMJEssiBFm7/W5cBqabUdwXUCE
Xp9num+Kq8ARMY0pArJ+Om+2v8QtCz2FbdoSP61LZ0C83uiioRkgoy91KBVXpZ6F
rmeBvDkPVLfSmYIs9JRHn/A4gx5eircl/WaTk+2FpgCXwUM3gYmQRWUz67qoOKLH
r3/rhIQzDWZcSN2ejNYYEA4C8rA3Xh2fwfTaNCifGypBDyZKuKZPH99kWSUd4gfB
Ui2D2HlcXiFeOL3jT30SkEVK3TRwS5FKYUicHm+ZwZDZqnjN6vwg6bSpbHXFF6T4
FJXu8AtBlTLkQcW9V4pnoTleZc76D0oUFumaueofgKPpDjBx1KFJYPqxJi78bavz
m+5okkhB+OSwRsd1bwieWv+LKr5ZoVk6nTD3FrrM2PE8uZu3/PJW81ljt+i0B2YO
T9cAB2t0NDrQw+EBVKI0Pq+6u+APqSafCypVdZgxPkLAGGgmqoxZJoLXTSpCkyRH
unRsmGOMqMid+B1ENUZ52as3nY6+sdncsiPB5zOELHGJMaWj2nxhpiz+PKCWnGRw
WZeN7JPJawwYqww28GnU1AtfWyB/fGVlGVfNjCzt3Eg83RygyLlVCAK52XZlybyJ
nDov6e8FzwpoGo0Oo/+J
=0GRK
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_10_01_17_+1000_xZ8Lp2nMbq74BLmc--
