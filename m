Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaKSFWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:22:25 -0500
Received: from ozlabs.org ([103.22.144.67]:53113 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbaKSFWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:22:23 -0500
Message-ID: <1416374519.32483.1.camel@concordia>
Subject: [git pull] Please pull mpe.git for-linus branch (for powerpc)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        haokexin@gmail.com, scottwood@freescale.com
Date: Wed, 19 Nov 2014 16:21:59 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cFnBl0cYDCIzAbFpCMPS"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cFnBl0cYDCIzAbFpCMPS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull one fix from Scott, he says:

  This patch fixes a crash (introduced in v3.18-rc1) in the FSL MSI driver
  when threaded IRQs are enabled.


The following changes since commit 8a97577a5967c1234ccc3bc1b45e4b1a58b39ea8=
:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mpe/linux (2014-11-04 11:18:29 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git for-linus

for you to fetch changes up to d7ce4377494adfaf8afb15ecf4f07d399bbf13d9:

  powerpc/fsl_msi: mark the msi cascade handler IRQF_NO_THREAD (2014-11-17 =
22:00:30 -0600)

----------------------------------------------------------------
Kevin Hao (1):
      powerpc/fsl_msi: mark the msi cascade handler IRQF_NO_THREAD

 arch/powerpc/sysdev/fsl_msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)




--=-cFnBl0cYDCIzAbFpCMPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJUbCkLAAoJEFHr6jzI4aWA2SQP/3c7P3oO3zZrc6JmRtkgwn/D
LwORvTZDbwQgYMEG9xHS3rM4ZESjxGmfpbFX3Tl4Pa0yUVXDFFpqIw4b8LTNtvak
SbB/w1DeeiJ02BTns2npSt8Te4Q+B6QybDf6Auu+C5HfqcnMiYLOrJy9qOs1pdUz
+h0UmPt2L8VXlnrBUQhz/O3J2yjvHcqQKD9G1lErC/5RlqmhT6/vALeg4siz0095
owsE9iMf5U7Ek2wrfIqGvOQSDQvoT+9LYQsG0d2EsFDj6xtMCei/j7jG5OaHiZu8
uwIihdy/pieEJTz/6UmlhITfgBjO6GiZlylRRruTtUqn6LgK+g7mmPuih3xPSTkh
H/edOK9FI1bm99NM9F11x+BphXti9OPfnl4/JhZw81F4UkXqqUKntiIUxJ9ls4LI
7dwWDLS/1us5r3sqIRl1s96g1M7niQ0Rq21G08dps5tiVBkfyrXxehmccMWSO8GV
9lhZ1ZnRixPkMZ4ae27f8bGuEfbVkAvgWnn5X2EB3Eid6k0QIrgLUZ8fmzW0Hru2
OQI1OAoc+YO/mgGqQX7bsnf9kellz3KEdNWdvf1lRByzdHgGYPK/gRSXeXRFhEkO
dr/+J6/eEsH0lSSgsbiOCapZnfF5JWxK1bofBeDgzn7KUEWvFBkzAM/kdfD2jE85
qu5og4pBwpa+JOacxpNY
=eEY3
-----END PGP SIGNATURE-----

--=-cFnBl0cYDCIzAbFpCMPS--

