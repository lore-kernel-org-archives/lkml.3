Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaK0Fxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:53:34 -0500
Received: from ozlabs.org ([103.22.144.67]:43129 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaK0Fxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:53:32 -0500
Message-ID: <1417067594.5810.1.camel@concordia>
Subject: [git pull] Please pull mpe.git for-linus branch (for powerpc)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        anton@samba.org, gwshan@linux.vnet.ibm.com, ldufour@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 27 Nov 2014 16:53:14 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ey6PsstDMCRWv7m7Lgp3"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ey6PsstDMCRWv7m7Lgp3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are five fixes for you to pull please.

I think these are all rc6 material, but I'm still learning so let me know i=
f
you disagree :)

They're all CC'ed to stable except the "Fix PE state format" one which went=
 in
this release.

cheers


The following changes since commit d7ce4377494adfaf8afb15ecf4f07d399bbf13d9=
:

  powerpc/fsl_msi: mark the msi cascade handler IRQF_NO_THREAD (2014-11-17 =
22:00:30 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git for-linus

for you to fetch changes up to 152d44a853e42952f6c8a504fb1f8eefd21fd5fd:

  powerpc: 32 bit getcpu VDSO function uses 64 bit instructions (2014-11-27=
 09:42:12 +1100)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Gavin Shan (2):
      powerpc/eeh: Fix PE state format
      powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVAT=
E

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Mahesh Salgaonkar (1):
      powerpc/powernv: Fix the hmi event version check.

 arch/powerpc/kernel/eeh_sysfs.c           | 2 +-
 arch/powerpc/kernel/vdso32/getcpu.S       | 4 ++--
 arch/powerpc/platforms/powernv/opal-hmi.c | 2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c | 2 +-
 arch/powerpc/xmon/xmon.c                  | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)




--=-ey6PsstDMCRWv7m7Lgp3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJUdrxXAAoJEFHr6jzI4aWA2BEP+wYanMFU/GFwsKpBmSOBo7qe
OhAQaq0G8jleC2UW8jVbw8tmBEh2I8PDLLRms/4x/FYafqomivN5iuRq3eBaFATA
LzFszluUUfwsISPcIO1OQXE5qGO8/YDiiOu6AJpAgbnMGKQNMia7z7pMs+lxDLSW
VUtjmUTjdVTFmfKgLW/j6D/XeLxjbpWvUIlCjnFMO1fO7CjfSQSqJS56mLL7htPe
F8Yt55J+ngcVJihviDc3XL7e4IpyoPT8Etwtt2GnX3oEnBKC8Hulv3eQCWE9waqZ
vwHRr4kIUHJdeaXkGk2PL8tKzjfM81OD9BGVQG8UL6niUg3zZQM0WJH66at57+mf
kRyb83RlntCWNxDsYuJOZvFpfjzPaW80du/sC69UotQAjjN3MuJbeH1moZmRSe8L
vpuLN9Kf3oS0dj1ClWB22m4KK6+SbGIgFzFJUzIZpJTjYCA+Tg6O1MmIaK/37moe
RUMyHL8P2GACmzSqGD00LSWIPQKl8GnLiddEHwYFSdEclXvyg1X4ftroC5Wjv/Gj
EjtwOCY4pm8lAjv6kjvLvj76xVWTIBbQIc3HgmsrezvFwBuSwwDRUK8k/m9D6oQo
Y9Ku/jAepIDAxGKzcZWN+zRZpQY8i4wqVEk9drQjtp+uYM+qYd9TX+Ji9Na/6yjM
9dTQFTOLdRascZ5r6pkr
=B/Qk
-----END PGP SIGNATURE-----

--=-ey6PsstDMCRWv7m7Lgp3--

