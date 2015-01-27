Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbA0F0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:26:39 -0500
Received: from ozlabs.org ([103.22.144.67]:60765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbbA0F0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:26:37 -0500
Message-ID: <1422336395.27133.3.camel@ellerman.id.au>
Subject: [git pull] Please pull mpe/linux.git powerpc-3.19-5 tag
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ldufour@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, shreyas@linux.vnet.ibm.com
Date: Tue, 27 Jan 2015 16:26:35 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7wH4UHCoAI0ARhp/Wi/z"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7wH4UHCoAI0ARhp/Wi/z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull two powerpc fixes for 3.19:

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc=
:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git tags/powerpc-=
3.19-5

for you to fetch changes up to 0eb13208aa16ca5517835ea8f3feef091a13b984:

  powerpc/powernv: Restore LPCR with LPCR_PECE1 cleared (2015-01-22 17:22:5=
7 +1100)

Laurent Dufour (1):
      powerpc/xmon: Fix another endiannes issue in RTAS call from xmon

Shreyas B. Prabhu (1):
      powerpc/powernv: Restore LPCR with LPCR_PECE1 cleared

 arch/powerpc/platforms/powernv/setup.c | 2 +-
 arch/powerpc/xmon/xmon.c               | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)



--=-7wH4UHCoAI0ARhp/Wi/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxyGLAAoJEFHr6jzI4aWAPpUQAKEw3znjngN4vM91AWvCXLf7
BfwBKCMWG7LIhFozABNfBaM5+R0PS+j6TMFE1Er01aRqpdzBsq6RFLS2bnaKwykU
jIc18YwNDKGu0Gg9HlUloUQ9j8iLtoCboHWR/dpCP6vAxmhdGrVR8tXlUsGr0cFd
kl+eTVRngDxbWA1P4RD+EDsiZtzrSE3qpwG/YKGn2pbLqCfYmeCkFetUZEO7FwwM
4WbwhyJuFu8VLVtWtWRMzc/Q6tb8feK/8DP7PCnhNTaoU25iAE5zoJKWR33GRpOd
Ao0GRKK3x3eyf+YZFoGP8QSiOpXBy6EZT3V1TIa78DSk8EfkfwBeXR7vL0qX1O2m
tUGVQ4nvCwdMQKoEjfOcyTNyLxZ7Ic3OYobK4sj+uI2tzHe3PlCfMy8Ws0qFZuNt
erLMsqlHT0Snfobw24lndZ/xwUXFr48N+TsIlc8SRS8Vc/M20NaeRvAq1WeTlyxJ
U7hWNgy7mTFQKwHAIIWxDhxDx3QeUQ7sm4RIyGdM/I9WcjYBfHU4eG6OrIWDV+QB
2WFc9D1YpJ999L9GEhFK2TXq12nbctnfTSDg5Bdy8S5ZDqQROufQplYqnIiz4o1p
/fvsV3Wxq0QQ6fB/OySUkrHkchfaHJsjegS3C7PbbZNu+51T2yflfkP+QtbZzVqv
cux+7syln3EghnQ4Oir7
=M7pu
-----END PGP SIGNATURE-----

--=-7wH4UHCoAI0ARhp/Wi/z--

