Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbbAEGKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:10:09 -0500
Received: from ozlabs.org ([103.22.144.67]:55325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbAEGKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:10:07 -0500
Message-ID: <1420438204.3860.3.camel@ellerman.id.au>
Subject: [git pull] Please pull mpe/linux.git powerpc-3.19-3 tag
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bobby.prani@gmail.com, hbathini@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Anton Blanchard <anton@samba.org>
Date: Mon, 05 Jan 2015 17:10:04 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZHudLhn7xfTOOdMwvg8X"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZHudLhn7xfTOOdMwvg8X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull some powerpc fixes for 3.19:

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6=
:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git tags/powerpc-=
3.19-3

for you to fetch changes up to 1be6f10f6f9caade3a053938cb80a2eed237e262:

  Revert "powerpc: Secondary CPUs must set cpu_callin_map after setting act=
ive and online" (2014-12-29 15:51:51 +1100)

----------------------------------------------------------------
powerpc fixes for 3.19

Wire up sys_execveat(). Tested on 32 & 64 bit.

Fix for kdump on LE systems with cpus hot unplugged.

Revert Anton's fix for "kernel BUG at kernel/smpboot.c:134!", this broke ot=
her
platforms, we'll do a proper fix for 3.20.

----------------------------------------------------------------
Hari Bathini (1):
      powerpc/kdump: Ignore failure in enabling big endian exception during=
 crash

Michael Ellerman (1):
      Revert "powerpc: Secondary CPUs must set cpu_callin_map after setting=
 active and online"

Pranith Kumar (1):
      powerpc: Wire up sys_execveat() syscall

 arch/powerpc/include/asm/kexec.h       | 10 ++++++++++
 arch/powerpc/include/asm/systbl.h      |  1 +
 arch/powerpc/include/asm/unistd.h      |  2 +-
 arch/powerpc/include/uapi/asm/unistd.h |  1 +
 arch/powerpc/kernel/machine_kexec_64.c |  2 +-
 arch/powerpc/kernel/smp.c              |  9 +--------
 arch/powerpc/platforms/pseries/lpar.c  |  8 +++++++-
 7 files changed, 22 insertions(+), 11 deletions(-)



--=-ZHudLhn7xfTOOdMwvg8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUqiq8AAoJEFHr6jzI4aWA8BUP/Ao644xK1jpCFILqVTKBeqLO
iswiA3qVLqG6pz/2qHxQjtOe2iKOMECRCfUaMR497t3OLmhdFTSntx27AE5+OTC2
sbO/jxsGAbxc5yvNEUjPMXBwG6M4cUAQnT63z2MmQjNQjKNvrnSv81Zca0vyN8Tz
Jr0HZbjeQfN0atIHJQZOnLKcvW//ir0UdXyfZkOvvU2FZ6nLuTUbG5jH7hjoW8bX
dRRj53TG81XtdpNqJE8MXVxSoB3K4UZCxEYxRtXrcv808vjorcBRPIojePHBfMl9
B/Lny9ZD4gq5WiDcHtPTwQ+SLm9a0HH//Wp4LQIrLWU2CafEKSXniFwfJwhaiztG
WS3SUtveUBhGdboRobjdQRkb1ZVLIs70huWWBJbCjym1mD5fFCnf55GEPSwX3LQM
7/zT2bN9QtCHIlk6kn4EsyTMI9Q39v0VIdhDo0LW7zWskJq1YkmdLjw85ukTHt/R
Wz6HdMM3vv07tDR/m2eDqnOSVktJ0afOMDYE6F/lrik3NOPHVxvYABEPt9HlcaJL
8dyOojjIWA7NHtAYujmlqrrjGtW6kdh6AzqgiurGdD6JL1Kbo58UkvRUT8GkwMGf
ygp7NIFzCjxSIoshFi3HD0sVkRCtsNeKqBhpa3lOsQQQkKxbABLHNp8B5nPw5jsn
KkJ5mUdC4KROlToZUOOD
=TEgk
-----END PGP SIGNATURE-----

--=-ZHudLhn7xfTOOdMwvg8X--

