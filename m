Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaBKMHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:07:54 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33599 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaBKMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:07:53 -0500
Message-ID: <52FA1294.7020809@monstr.eu>
Date: Tue, 11 Feb 2014 13:07:48 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.14
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bs2QNnSxBhg0OV5NGApb9rIS55dWwqqR0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bs2QNnSxBhg0OV5NGApb9rIS55dWwqqR0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull these 3 Microblaze fixes to your tree.

Thanks,
Michal


The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9=
ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/microblaze-3.14-rc3

for you to fetch changes up to a49f56eec54d864ba0fda838e4c8bf5c72f3eb08:

  microblaze: Fix a typo when disabling stack protection (2014-02-10 07:4=
4:11 +0100)

----------------------------------------------------------------
Microblaze fixes for 3.14-rc3

- Fix two compilation issues - HZ, readq/writeq
- Fix stack protection support

----------------------------------------------------------------
Edgar E. Iglesias (1):
      microblaze: Fix a typo when disabling stack protection

Michal Simek (2):
      microblaze: Fix missing HZ macro
      microblaze: Define readq and writeq IO helper function

 arch/microblaze/include/asm/delay.h | 2 ++
 arch/microblaze/include/asm/io.h    | 6 ++++++
 arch/microblaze/kernel/head.S       | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--bs2QNnSxBhg0OV5NGApb9rIS55dWwqqR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL6EpQACgkQykllyylKDCFDCACfc22Uq32PVLawqUqIQmWSLASq
3kkAoJ0hMwd8gQez4iTmk+V8fuJ5W0di
=RXsa
-----END PGP SIGNATURE-----

--bs2QNnSxBhg0OV5NGApb9rIS55dWwqqR0--
