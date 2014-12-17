Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaLQMHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:07:04 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33348 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaLQMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:07:02 -0500
Message-ID: <549171E2.5000905@monstr.eu>
Date: Wed, 17 Dec 2014 13:06:58 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.19-rc1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="v3guXMN9E5afuQKWhF0u6U2O6KnJiuMN5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v3guXMN9E5afuQKWhF0u6U2O6KnJiuMN5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull this one patch to your tree.

Thanks,
Michal


The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d7=
1d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.19-rc1

for you to fetch changes up to 3a8e3265179b7e6394d7aab4d6df5651b49e7243:

  microblaze: Fix mmap for cache coherent memory (2014-12-17 12:59:59 +01=
00)

----------------------------------------------------------------
Microblaze patches for 3.19-rc1

- Fix mmap for cache coherent memory

----------------------------------------------------------------
Lars-Peter Clausen (1):
      microblaze: Fix mmap for cache coherent memory

 arch/microblaze/include/asm/pgtable.h |  1 +
 arch/microblaze/kernel/dma.c          | 27 +++++++++++++++++++++++++++
 arch/microblaze/mm/consistent.c       | 25 ++++++++++++++++++++-----
 3 files changed, 48 insertions(+), 5 deletions(-)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--v3guXMN9E5afuQKWhF0u6U2O6KnJiuMN5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlSRceIACgkQykllyylKDCE3YgCfR2V5IJnrRoVo6EJtGpgPKYBe
JugAniGZsr237+m0Xp08mfX0HC8cfBA3
=mTwi
-----END PGP SIGNATURE-----

--v3guXMN9E5afuQKWhF0u6U2O6KnJiuMN5--
