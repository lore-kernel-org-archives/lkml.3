Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbaJaNTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:19:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41655 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaJaNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:19:12 -0400
Message-ID: <54538C4C.9000109@monstr.eu>
Date: Fri, 31 Oct 2014 14:19:08 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.18-rc3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="c3plSdxgcmvOmL6nGfPrWhDU2LfQUKqlT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c3plSdxgcmvOmL6nGfPrWhDU2LfQUKqlT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these 3 fixes to your tree.

Thanks,
Michal


The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb=
2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.18-rc3

for you to fetch changes up to a4f174dee4ae842e07cab7eeec194a3e60925c8d:

  microblaze: Wire up bpf syscall (2014-10-27 09:25:34 +0100)

----------------------------------------------------------------
Microblaze patches for 3.18-rc3

- Wire-up new syscall
- Fix PCI bug
- Fix Kconfig warning

----------------------------------------------------------------
Michal Simek (3):
      microblaze: Fix missing NR_CPUS in menuconfig
      microblaze: Fix IO space breakage after of_pci_range_to_resource() =
change
      microblaze: Wire up bpf syscall

 arch/microblaze/Kconfig                   | 4 ++++
 arch/microblaze/include/asm/unistd.h      | 2 +-
 arch/microblaze/include/uapi/asm/unistd.h | 1 +
 arch/microblaze/kernel/syscall_table.S    | 1 +
 arch/microblaze/pci/pci-common.c          | 9 +++++++--
 5 files changed, 14 insertions(+), 3 deletions(-)

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--c3plSdxgcmvOmL6nGfPrWhDU2LfQUKqlT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlRTjEwACgkQykllyylKDCHwXgCdGoK+MHU5DTJN83hOY4g/3FhU
eX8AoJFvRVNQCq71NniGG5dry0AOIj/j
=hN2l
-----END PGP SIGNATURE-----

--c3plSdxgcmvOmL6nGfPrWhDU2LfQUKqlT--
