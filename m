Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaA1KDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:03:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47938 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaA1KDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:03:13 -0500
Message-ID: <52E7805B.5050909@monstr.eu>
Date: Tue, 28 Jan 2014 11:03:07 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.14
References: <5280F58F.4060900@monstr.eu>
In-Reply-To: <5280F58F.4060900@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ldeK93jceUQL7gdH1KIiXVjRCoIkj3HVp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ldeK93jceUQL7gdH1KIiXVjRCoIkj3HVp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these Microblaze patches to your tree.

Thanks,
Michal

The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64=
be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.14-rc1

for you to fetch changes up to c0d68cea2db34a510f4d67b90aab1c48bc47461e:

  microblaze: Add missing v8.50.a version (2014-01-27 11:31:37 +0100)

----------------------------------------------------------------
Microblaze patches for 3.14-rc1

- Add CCF support
- Fix BS=3D0 compilation
- Wire up defconfig
- Some minor cleanups and fixes

----------------------------------------------------------------
Geert Uytterhoeven (4):
      microblaze: Wire up defconfig to mmu_defconfig
      microblaze: Remove _fdt_start casts
      microblaze: Remove duplicate declarations of _stext[] and _etext[]
      microblaze/uapi: Use Kbuild logic to include <asm-generic/types.h>

Michal Simek (10):
      microblaze: Simplify fcpu helper function
      microblaze: Add support for CCF
      microblaze: Add NOTES section to linker script
      microblaze: timer: Use generic sched_clock implementation
      microblaze: timer: Do not initialized system timer twice
      microblaze: Define read/write{b,w,l}_relaxed MMIO
      microblaze: Disable stack protection from bootloader
      microblaze: Fix compilation error for BS=3D0
      microblaze: Fix missing bracket in printk
      microblaze: Add missing v8.50.a version

 arch/microblaze/Kconfig                       |  2 ++
 arch/microblaze/Makefile                      |  2 ++
 arch/microblaze/include/asm/cpuinfo.h         |  9 ++++++---
 arch/microblaze/include/asm/io.h              |  8 ++++++++
 arch/microblaze/include/asm/sections.h        |  1 -
 arch/microblaze/include/uapi/asm/Kbuild       |  3 ++-
 arch/microblaze/include/uapi/asm/types.h      |  1 -
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |  3 ---
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |  2 --
 arch/microblaze/kernel/cpu/cpuinfo.c          | 24 +++++++++++++++++++++=
+--
 arch/microblaze/kernel/head.S                 |  4 ++++
 arch/microblaze/kernel/hw_exception_handler.S | 49 +++++++++++++++++++++=
++++++++++++++++------------
 arch/microblaze/kernel/setup.c                | 10 ++++++----
 arch/microblaze/kernel/timer.c                | 51 +++++++++++++++++++++=
+++++++-----------------------
 arch/microblaze/kernel/vmlinux.lds.S          |  1 +
 15 files changed, 118 insertions(+), 52 deletions(-)
 delete mode 100644 arch/microblaze/include/uapi/asm/types.h


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--ldeK93jceUQL7gdH1KIiXVjRCoIkj3HVp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLngFsACgkQykllyylKDCF1FQCgl5EdgSUCNy9cAqUW4ylLYEV/
ZVQAn3FGhBLLzk7NFgjdRvtP5W7SNwF0
=ss5v
-----END PGP SIGNATURE-----

--ldeK93jceUQL7gdH1KIiXVjRCoIkj3HVp--
