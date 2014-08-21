Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaHUJL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:11:26 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57147 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaHUJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:11:24 -0400
Message-ID: <53F5B7B8.3050402@monstr.eu>
Date: Thu, 21 Aug 2014 11:11:20 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.17-rc2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Olsk31JelnP6xwGkcUoiBdp8bER819r2o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Olsk31JelnP6xwGkcUoiBdp8bER819r2o
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these 3 commits to your tree. It is just about adding new
syscalls to 3.17.

Thanks,
Michal


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2=
b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.17-rc2

for you to fetch changes up to 83c43c498a0a269e8334e53994c75dad8824cca2:

  microblaze: Wire-up memfd_create syscall (2014-08-21 10:19:28 +0200)

----------------------------------------------------------------
Microblaze patches for 3.17-rc2

- Wire-up seccomp/getrandom/memfd_create syscalls

----------------------------------------------------------------
Michal Simek (3):
      microblaze: Wire-up seccomp syscall
      microblaze: Wire-up getrandom syscall
      microblaze: Wire-up memfd_create syscall

 arch/microblaze/include/uapi/asm/unistd.h | 3 +++
 arch/microblaze/kernel/syscall_table.S    | 3 +++
 2 files changed, 6 insertions(+)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Olsk31JelnP6xwGkcUoiBdp8bER819r2o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP1t7gACgkQykllyylKDCFFowCdENx9RjeeQweK6PfxON/R6uxk
LDEAnRUDsLaYTDBOVuD88OuH32TP/8A3
=hyEZ
-----END PGP SIGNATURE-----

--Olsk31JelnP6xwGkcUoiBdp8bER819r2o--
