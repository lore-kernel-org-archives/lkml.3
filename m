Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3GJNOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:14:37 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48851 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJNOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:14:36 -0400
Message-ID: <51DD5E32.8030603@monstr.eu>
Date: Wed, 10 Jul 2013 15:14:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.11
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LTEQMCDDACEVUFKDTMJG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LTEQMCDDACEVUFKDTMJG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

this Microblaze merge window is quite minimal.
I have also added to my branch one xilinx systemace sparse fix
because haven't got any reply from block maintainer.

Thanks,
Michal


The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab8=
2d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git next

for you to fetch changes up to 4937a269cb063915d50e47c68493679b7fe0ffb7:

  xilinx systemace: Fix sparse warnings (2013-07-10 07:47:12 +0200)

----------------------------------------------------------------
Graeme Smecher (1):
      microblaze: Don't mark arch_kgdb_ops as const.

Michal Simek (3):
      microblaze: Enable KGDB in defconfig
      microblaze: Move __NR_syscalls from uapi
      xilinx systemace: Fix sparse warnings

 arch/microblaze/configs/mmu_defconfig     | 4 +++-
 arch/microblaze/include/asm/unistd.h      | 3 +++
 arch/microblaze/include/uapi/asm/unistd.h | 2 --
 arch/microblaze/kernel/kgdb.c             | 2 +-
 drivers/block/xsysace.c                   | 4 ++--
 5 files changed, 9 insertions(+), 6 deletions(-)

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2LTEQMCDDACEVUFKDTMJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHdXjIACgkQykllyylKDCFcLgCfZ2gr6U1/jrvirPAlpJWCyUP8
bosAoIRxe5BCHDMv7rGEXcVi+QOAIH8N
=RBq7
-----END PGP SIGNATURE-----

------enig2LTEQMCDDACEVUFKDTMJG--
