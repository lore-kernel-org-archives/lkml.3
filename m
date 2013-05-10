Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3EJFzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 01:55:38 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:44216 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3EJFzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 01:55:37 -0400
Message-ID: <518C8BD6.5080306@monstr.eu>
Date: Fri, 10 May 2013 07:55:34 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.10
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VBUXDCBEXISREXPXAKPA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VBUXDCBEXISREXPXAKPA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these changes to you tree.

Thanks,
Michal


The following changes since commit e0fd9affeb64088eff407dfc98bbd3a5c17ea4=
79:

  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel=
/git/roland/infiniband (2013-05-08 15:29:48 -0700)

are available in the git repository at:


  git://git.monstr.eu/linux-2.6-microblaze.git next

for you to fetch changes up to a047775e7eff511a529bf65f3b3e9c11443789b2:

  microblaze: Enable IRQ in arch_cpu_idle (2013-05-09 10:46:16 +0200)

----------------------------------------------------------------
Dan Christensen (1):
      microblaze: Set the default irq_domain

Michal Simek (7):
      microblaze: pci: Remove duplicated header
      microblaze: Do not use r6 in head.S
      microblaze: Fix initrd support
      microblaze: Do not select OPT_LIB_ASM by default
      microblaze: Add support for new cpu versions and target architectur=
e
      microblaze: Fix uaccess_ok macro
      microblaze: Enable IRQ in arch_cpu_idle

Wei Yongjun (1):
      microblaze: pci: Remove duplicated include from pci-common.c

 arch/microblaze/configs/mmu_defconfig |  1 -
 arch/microblaze/include/asm/pci.h     |  2 --
 arch/microblaze/include/asm/uaccess.h | 30 +++++++++++++++++++----------=
-
 arch/microblaze/kernel/cpu/cpuinfo.c  |  5 +++++
 arch/microblaze/kernel/head.S         | 20 ++++++++++----------
 arch/microblaze/kernel/intc.c         |  2 ++
 arch/microblaze/kernel/process.c      |  5 +++++
 arch/microblaze/mm/init.c             |  9 +++++----
 arch/microblaze/pci/pci-common.c      |  1 -
 9 files changed, 46 insertions(+), 29 deletions(-)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2VBUXDCBEXISREXPXAKPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGMi9YACgkQykllyylKDCEDyACcD9aHcTxRIh9WO0QyOXyPnvo1
pBsAoIvi5Be31AivenNv3wK0Iw3P1C5v
=rKIq
-----END PGP SIGNATURE-----

------enig2VBUXDCBEXISREXPXAKPA--
