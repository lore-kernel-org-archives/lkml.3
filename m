Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaJCVLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:11:06 -0400
Received: from sauhun.de ([89.238.76.85]:42371 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaJCVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:11:03 -0400
Date: Fri, 3 Oct 2014 23:10:58 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.17
Message-ID: <20141003211053.GA2176@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here are two i2c driver bugfixes which would be nice to have in 3.17.

Thanks,

   Wolfram


The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 86b59bbfae2a895aa26b3d15f31b1a705dbfede1:

  i2c: qup: Fix order of runtime pm initialization (2014-10-03 03:20:47 +0200)

----------------------------------------------------------------
Alexandru M Stan (1):
      i2c: rk3x: fix 0 length write transfers

Andy Gross (1):
      i2c: qup: Fix order of runtime pm initialization

 drivers/i2c/busses/i2c-qup.c  | 12 ++++++++----
 drivers/i2c/busses/i2c-rk3x.c |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULxDdAAoJEBQN5MwUoCm2/oIP/3K//tzMjd5miETujktjP/Sw
BD044pHTJniqpKeJn4U4KT++9BFAsUdM4LMgUgg5Z8tqHDO/McVLcg3BWxSCRM1y
neJOKHPaGsGewB/ba7yPjOa9DPpwSbMGHDA8uUQvfXBgf0Zp4xJ8u5adfJDrm0VJ
BZ0GOLdXBrDQjlMKdxYYeMKJaVa62ULapGIwQCgM2B7qyORB0FsoBikchxQq4TNM
3DgjFJYzlIIjRobN0fAInO3uV/JILvd4Vl7p4gw7oMx0F5uUufBs09UtfsYADR4F
TZQzj+wZIu90IpeFq7RgVa/p7m/zwbAbDyzUoPKouxmarjdmj4kIq5Y3DDYP1RB2
Sif34dlSbyjPTmypzSDEuXTIyc217NTt4fQ6OBU9ff60DVSEzcNG4dKdP6+WgPvh
2BY9tdpJ47c2Jn8PdIGrPZPC23onm3P0jr4DnIclYMo/ZD+qD1Vz9R5J6BjWs1XJ
yhrk/fDHt4u4M97nsGSjZIFVUzm5QpOPORw6UrINjTd0ZbXzxJfeDzgJ8jacxXK6
KRSwKXbBeELG6E4ncweEThwoAs/eDsgejVk3jOlZ6r5P6pibe5WANJ9vCVjI0Ivd
5sUMkx/EJuMDoToz1nBsoqSxEJ/Y2EuGmMh5U5E3u8vrTKLliz8PIlJK9jrBM+k9
TR7+fPbb2R2pIXxhvKuG
=20Vm
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
