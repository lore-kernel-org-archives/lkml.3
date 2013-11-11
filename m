Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3KKPT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:19:57 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48052 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3KKPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:19:49 -0500
Message-ID: <5280F58F.4060900@monstr.eu>
Date: Mon, 11 Nov 2013 16:19:43 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.13
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iFmJkv1NJ3CmVBLI4f36Ie3vx5auwshi0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iFmJkv1NJ3CmVBLI4f36Ie3vx5auwshi0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these Microblaze patches to your tree.

Thanks,
Michal


The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb=
52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.13-rc1

for you to fetch changes up to 63d7bd1b171d5e7190c50dd3e48b1c561d7803d8:

  microblaze: Remove incorrect file path (2013-11-08 15:23:55 +0100)

----------------------------------------------------------------
Microblaze patches for 3.13-rc1

- Get rid of NO_MMU Kconfig
- mmap2 fixups
- Some minor cleanups

----------------------------------------------------------------
Michael Opdenacker (1):
      microblaze: Remove unused NO_MMU Kconfig parameter

Michal Simek (5):
      microblaze: Calculate kernel pad automatically
      microblaze: Remove deprecated IRQF_DISABLED
      microblaze: Use predefined SYSCALL_DEFINE macro
      microblaze: Fix bug with mmap2 syscall MB implementation
      microblaze: Remove incorrect file path

 arch/microblaze/Kconfig                       |  9 ---------
 arch/microblaze/boot/dts/Makefile             |  2 --
 arch/microblaze/kernel/head.S                 |  2 +-
 arch/microblaze/kernel/hw_exception_handler.S |  4 ++--
 arch/microblaze/kernel/sys_microblaze.c       | 17 ++++++++++++++---
 arch/microblaze/kernel/syscall_table.S        |  2 +-
 arch/microblaze/kernel/timer.c                |  2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--iFmJkv1NJ3CmVBLI4f36Ie3vx5auwshi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKA9Y8ACgkQykllyylKDCEUCwCff8YaUt6kQ0lUlEQYO0CAUYZF
lMMAnjgfnbHLwBMf+NoSgaonUfpcvBJ7
=ufLF
-----END PGP SIGNATURE-----

--iFmJkv1NJ3CmVBLI4f36Ie3vx5auwshi0--
