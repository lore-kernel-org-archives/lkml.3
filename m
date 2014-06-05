Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaFELKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:10:07 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:49749 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFELKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:10:06 -0400
Message-ID: <53905009.5010709@monstr.eu>
Date: Thu, 05 Jun 2014 13:10:01 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.16
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="j03CpH8gi1qVHEdefm5SaH5lSdSteuw4X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j03CpH8gi1qVHEdefm5SaH5lSdSteuw4X
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these Microblaze changes to your tree.

Thanks,
Michal

The following changes since commit fad01e866afdbe01a1f3ec06a39c3a8b9e1970=
14:

  Linux 3.15-rc8 (2014-06-01 19:12:24 -0700)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.16-rc1

for you to fetch changes up to 225fba216261b0e24273f5f4eee504e3c7bd0255:

  microblaze: Fix typo in head.S s/substract/subtract/ (2014-06-05 13:02:=
02 +0200)

----------------------------------------------------------------
Microblaze patches for 3.16-rc1

- Clean PCI and DMA handling
- Use generic device.h
- Some cleanups

----------------------------------------------------------------
Antonio Ospite (1):
      microblaze: Fix typo in head.S s/substract/subtract/

Michal Simek (8):
      microblaze: Enable SERIAL_OF_PLATFORM
      microblaze: Return default dma operations
      microblaze: Do not setup pci_dma_ops
      microblaze: Cleanup PCI_DRAM_OFFSET handling
      microblaze: Clean device dma_ops structure
      microblaze: Remove device_to_mask
      microblaze: Do not setup empty unmap_sg function
      microblaze: Use generic device.h

Paul Bolle (1):
      microblaze: remove check for CONFIG_XILINX_CONSOLE

 arch/microblaze/configs/mmu_defconfig     |  1 +
 arch/microblaze/configs/nommu_defconfig   |  1 +
 arch/microblaze/include/asm/Kbuild        |  1 +
 arch/microblaze/include/asm/device.h      | 26 -------------------------=
-
 arch/microblaze/include/asm/dma-mapping.h | 25 +------------------------=

 arch/microblaze/include/asm/io.h          |  3 ---
 arch/microblaze/include/asm/pci.h         |  8 --------
 arch/microblaze/kernel/dma.c              | 30 +++----------------------=
-----
 arch/microblaze/kernel/head.S             |  2 +-
 arch/microblaze/kernel/setup.c            | 34 +------------------------=
---------
 arch/microblaze/pci/pci-common.c          | 19 -------------------
 drivers/of/platform.c                     |  3 ---
 12 files changed, 9 insertions(+), 144 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/device.h



--j03CpH8gi1qVHEdefm5SaH5lSdSteuw4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOQUAkACgkQykllyylKDCFSqwCfSvuSX4d6r2/uWm3cI04Bypco
JkIAmwSEV1UK11JFw4lEylUAmYTQWujW
=Q926
-----END PGP SIGNATURE-----

--j03CpH8gi1qVHEdefm5SaH5lSdSteuw4X--
