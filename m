Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3FDHq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:46:26 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:35524 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744Ab3FDHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:46:24 -0400
Message-ID: <51AD9B4D.5060705@monstr.eu>
Date: Tue, 04 Jun 2013 09:46:21 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.10-rc5
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2MLOMGBRGFDPCCVDXBQGS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2MLOMGBRGFDPCCVDXBQGS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these two fixes to your tree.
One is fixing warning reported by sparse and the second warning
was reported by Geert in his build regressions/improvements status update=

for -rc4.

Thanks,
Michal

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa=
6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git next

for you to fetch changes up to 62bc82a82bb1e2b5ee5048c088af7260ddb2b7b5:

  microblaze: Use static inline functions in cacheflush.h (2013-06-03 11:=
33:23 +0200)

----------------------------------------------------------------
Michal Simek (2):
      microblaze: Fix sparse warnings
      microblaze: Use static inline functions in cacheflush.h

 arch/microblaze/include/asm/cacheflush.h | 34 ++++++++++++++++++--------=
--------
 arch/microblaze/include/asm/uaccess.h    |  4 ++--
 2 files changed, 20 insertions(+), 18 deletions(-)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2MLOMGBRGFDPCCVDXBQGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGtm00ACgkQykllyylKDCEzYgCeJs55dCUiijzLbLCRGAMDI+mt
sZwAoIOm9XM1/UkCACE5OzsfmdD2Cjep
=Bf5u
-----END PGP SIGNATURE-----

------enig2MLOMGBRGFDPCCVDXBQGS--
