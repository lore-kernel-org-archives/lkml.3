Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaDKGR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:17:29 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53342 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaDKGR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:17:27 -0400
Message-ID: <534788F3.8090002@monstr.eu>
Date: Fri, 11 Apr 2014 08:17:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.15
References: <5280F58F.4060900@monstr.eu> <52E7805B.5050909@monstr.eu>
In-Reply-To: <52E7805B.5050909@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7EQu0H6GiPoj2CrgLUFiOBj9DjnpQ2DkD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7EQu0H6GiPoj2CrgLUFiOBj9DjnpQ2DkD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these Microblaze patches to your tree.

Thanks,
Michal

The following changes since commit fa389e220254c69ffae0d403eac4146171062d=
08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.15-rc1

for you to fetch changes up to a66a626538af65cbfc611e2b2fce500ed3f24518:

  microblaze: Use asm-generic/io.h (2014-04-07 14:25:53 +0200)

----------------------------------------------------------------
Microblaze patches for 3.15-rc1

- Use asm-generic/io.h and fix intc/timer code
- Clean platform handling
- Enable some syscalls

----------------------------------------------------------------
Guenter Roeck (2):
      microblaze: Rename global function heartbeat()
      microblaze: Drop architecture-specific declaration of early_printk

Michal Simek (12):
      microblaze: Enable pselect6 syscall
      microblaze: Wire-up preadv/pwritev in syscall table
      microblaze: Wire-up new system calls sched_setattr/getattr
      microblaze: Make intc driver endian aware
      microblaze: Make timer driver endian aware
      microblaze: Fix sparse warning because of missing cpu.h header
      microblaze: Fix compilation failure because of release_thread
      microblaze: Move DTS file to common location at boot/dts folder
      microblaze: Sort Kconfig options
      microblaze: Remove generic platform
      microblaze: Remove platform folder
      microblaze: Use asm-generic/io.h

 arch/microblaze/Kconfig                         |  54 ++++++++++++------=
------
 arch/microblaze/{platform =3D> }/Kconfig.platform |  55 ++++++++++++++++=
+-------
 arch/microblaze/Makefile                        |   1 -
 arch/microblaze/boot/dts/system.dts             | 367 ++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 arch/microblaze/include/asm/io.h                | 302 ++++++------------=
-------------------------------------------------------------------------=
----------------------------------------
 arch/microblaze/include/asm/processor.h         |   2 +-
 arch/microblaze/include/asm/setup.h             |   6 +--
 arch/microblaze/include/uapi/asm/unistd.h       |   6 ++-
 arch/microblaze/kernel/Makefile                 |   2 +-
 arch/microblaze/kernel/heartbeat.c              |   4 +-
 arch/microblaze/kernel/intc.c                   |  51 ++++++++++++++++++=
-----
 arch/microblaze/{platform =3D> kernel}/platform.c |   0
 arch/microblaze/kernel/process.c                |   1 +
 arch/microblaze/kernel/signal.c                 |   2 +-
 arch/microblaze/kernel/syscall_table.S          |   8 ++--
 arch/microblaze/kernel/timer.c                  |  66 ++++++++++++++++++=
+++--------
 arch/microblaze/mm/consistent.c                 |   2 +-
 arch/microblaze/mm/init.c                       |   2 +-
 arch/microblaze/mm/pgtable.c                    |   5 ++-
 arch/microblaze/platform/Makefile               |   6 ---
 arch/microblaze/platform/generic/Kconfig.auto   |  61 ------------------=
---------
 arch/microblaze/platform/generic/Makefile       |   3 --
 arch/microblaze/platform/generic/system.dts     | 366 ------------------=
-------------------------------------------------------------------------=
--------------------------------------------------------------------
 23 files changed, 558 insertions(+), 814 deletions(-)
 rename arch/microblaze/{platform =3D> }/Kconfig.platform (51%)
 mode change 120000 =3D> 100644 arch/microblaze/boot/dts/system.dts
 rename arch/microblaze/{platform =3D> kernel}/platform.c (100%)
 delete mode 100644 arch/microblaze/platform/Makefile
 delete mode 100644 arch/microblaze/platform/generic/Kconfig.auto
 delete mode 100644 arch/microblaze/platform/generic/Makefile
 delete mode 100644 arch/microblaze/platform/generic/system.dts

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--7EQu0H6GiPoj2CrgLUFiOBj9DjnpQ2DkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNHiPMACgkQykllyylKDCGYeACdG4NyxmjA9KDbw27j+KB3KXhu
rWYAn3mA/tO7RL1Q5XhBGyYKhfOF9bWZ
=zL2W
-----END PGP SIGNATURE-----

--7EQu0H6GiPoj2CrgLUFiOBj9DjnpQ2DkD--
