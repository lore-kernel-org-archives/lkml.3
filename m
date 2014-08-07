Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaHGNyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:54:36 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40167 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbaHGNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:54:35 -0400
Message-ID: <53E38516.9040100@monstr.eu>
Date: Thu, 07 Aug 2014 15:54:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.17
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8GTbFAaTxSh42FAKiUro6b9SgoTD1tIXt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8GTbFAaTxSh42FAKiUro6b9SgoTD1tIXt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these Microblaze changes to your tree.

Thanks,
Michal


The following changes since commit 163e40743f730e0982b0df28e57e0bed71442a=
77:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kerne=
l/git/groeck/linux-staging (2014-07-08 12:08:33 -0700)

are available in the git repository at:


  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.17-rc1

for you to fetch changes up to ef264cf0c490cc9d46edb3b6aa082d23a9506e2d:

  microblaze: Change libgcc-style functions from lib-y to obj-y (2014-07-=
18 14:26:09 +0200)

----------------------------------------------------------------
Microblaze patches for 3.17-rc1

- Add new syscall and fix comment
- Fix udelay implementation
- Fix libgcc for modules

----------------------------------------------------------------
David Holsgrove (1):
      microblaze: Change libgcc-style functions from lib-y to obj-y

Michal Simek (3):
      microblaze: delay.h fix udelay and ndelay for 8 bit args
      microblaze: Add syscall number comment
      microblaze: Wire-up renameat2 syscall

 arch/microblaze/include/asm/delay.h       | 28 ++++++++++++++++++++++---=
---
 arch/microblaze/include/uapi/asm/unistd.h |  1 +
 arch/microblaze/kernel/syscall_table.S    |  3 ++-
 arch/microblaze/lib/Makefile              | 14 +++-----------
 4 files changed, 28 insertions(+), 18 deletions(-)

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--8GTbFAaTxSh42FAKiUro6b9SgoTD1tIXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlPjhRcACgkQykllyylKDCGDfwCgiQ0tCPtBG7OTfL+vII72Dvc9
/q0An22MZamQ5Ooiqtubd9RJ4vNiU7aT
=/PBg
-----END PGP SIGNATURE-----

--8GTbFAaTxSh42FAKiUro6b9SgoTD1tIXt--
