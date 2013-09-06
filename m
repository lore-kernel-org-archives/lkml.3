Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903Ab3IFJJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:09:42 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35328 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IFJJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:09:41 -0400
Message-ID: <52299BD2.2020307@monstr.eu>
Date: Fri, 06 Sep 2013 11:09:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="s4RRswlOliVi9lI3sukp3fPruWL5TCIcd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s4RRswlOliVi9lI3sukp3fPruWL5TCIcd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these Microblaze patches to your tree.

Thanks,
Michal


The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c1921=
3e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.12-rc1

for you to fetch changes up to 54ea21f0785fd01fb3279d42fe6670cef64cf648:

  microblaze: Show message when reset gpio is not present (2013-09-04 17:=
01:37 +0200)

----------------------------------------------------------------
Microblaze patches for 3.12-rc1

PCI fixes
Selfmod code removing
Intc and timer fixes
Adding new MB versions
Minor fixes

----------------------------------------------------------------
Andrew Murray (1):
      of/pci: Use of_pci_range_parser

Jason Wu (1):
      microblaze: Add linux.bin.ub target

Michal Simek (13):
      microblaze: Remove selfmodified feature
      microblaze: intc: Remove unused headers
      microblaze: intc: Update header
      microblaze: intc: Using irqchip
      microblaze: intc: Clean driver init function
      microblaze: intc: Remove unused header
      microblaze: timer: Use CLKSRC_OF initialization
      microblaze: timer: Clear driver init function
      microblaze: timer: Remove unused header
      microblaze: timer: Update header
      microblaze: timer: Replace microblaze_ prefix by xilinx_
      microblaze: Add PVR version string for MB v9.0 and v9.1
      microblaze: Show message when reset gpio is not present

 arch/microblaze/Kconfig                   |   1 +
 arch/microblaze/Makefile                  |   3 +-
 arch/microblaze/boot/Makefile             |   7 +++--
 arch/microblaze/include/asm/selfmod.h     |  24 ---------------
 arch/microblaze/kernel/Makefile           |   2 --
 arch/microblaze/kernel/cpu/cpuinfo.c      |   2 ++
 arch/microblaze/kernel/intc.c             |  85 +++++++++++++++++++++++-=
-----------------------------
 arch/microblaze/kernel/irq.c              |  10 +++++--
 arch/microblaze/kernel/reset.c            |   6 +++-
 arch/microblaze/kernel/selfmod.c          |  81 ------------------------=
--------------------------
 arch/microblaze/kernel/setup.c            |  10 ++++---
 arch/microblaze/kernel/timer.c            | 186 ++++++++++++++++++++++++=
+++++++++++++++++++++++--------------------------------------------------=
------------------
 arch/microblaze/pci/pci-common.c          | 106 ++++++++++++++++++++++++=
-----------------------------------------
 arch/microblaze/platform/Kconfig.platform |  22 --------------
 14 files changed, 178 insertions(+), 367 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/selfmod.h
 delete mode 100644 arch/microblaze/kernel/selfmod.c


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--s4RRswlOliVi9lI3sukp3fPruWL5TCIcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIpm9IACgkQykllyylKDCGsEgCfXOCKL9ZWxzhHn/VGlLobJKbt
b+IAn0uqvjNKqnHSyEURaLBnoyn2J4SV
=sph4
-----END PGP SIGNATURE-----

--s4RRswlOliVi9lI3sukp3fPruWL5TCIcd--
