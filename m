Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab3E1HvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:51:08 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35975 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab3E1HvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:51:05 -0400
Message-ID: <51A461E1.2000301@monstr.eu>
Date: Tue, 28 May 2013 09:50:57 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.10-rc4
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2FSQBIDEXQJWXJVRKACND"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FSQBIDEXQJWXJVRKACND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull the following fixes to your tree.
One patch fix futex support and my patches fix warnings
which were reported by Geert's regression testing.

Thanks,
Michal


The following changes since commit 674825d05001e218afe5a04438683e1e597e14=
fb:

  Merge tag 'fixes-for-3.10-rc2-tag' of git://git.kernel.org/pub/scm/linu=
x/kernel/git/sstabellini/xen (2013-05-13 19:03:49 -0700)

are available in the git repository at:


  git://git.monstr.eu/linux-2.6-microblaze.git next

for you to fetch changes up to f6a12a7d0b1a70e969ae4f6d7c5201cdaf6edde0:

  microblaze: Reversed logic in futex cmpxchg (2013-05-27 12:29:35 +0200)=


----------------------------------------------------------------
Meyer, Kirk (1):
      microblaze: Reversed logic in futex cmpxchg

Michal Simek (2):
      microblaze: Initialize temp variable to remove compilation warning
      microblaze: Use proper casting for inb/inw/inl in io.h

 arch/microblaze/include/asm/futex.h | 2 +-
 arch/microblaze/include/asm/io.h    | 6 +++---
 arch/microblaze/kernel/cpu/cache.c  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2FSQBIDEXQJWXJVRKACND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGkYeYACgkQykllyylKDCEgkgCfaQ86/4fI5K6buMvf2vSVflFx
u+IAoJUlpefVSQaE9e40StAGCj0isFs7
=/JtR
-----END PGP SIGNATURE-----

------enig2FSQBIDEXQJWXJVRKACND--
