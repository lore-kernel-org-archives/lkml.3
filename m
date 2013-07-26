Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3GZMKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:10:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33999 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3GZMKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:10:07 -0400
Message-ID: <51F26716.6030701@monstr.eu>
Date: Fri, 26 Jul 2013 14:09:58 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: Zynq clk fixes
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1to5Skg0gktRk4MF1qcMUmXNjv4JNxSXq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1to5Skg0gktRk4MF1qcMUmXNjv4JNxSXq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mike, [cc: Arnd and Olof]

Soren has found two bug fixes in zynq clk code.
Can you please add these two patches to your tree?
Will be great if you can add them to v3.11.

Arnd, Olof: I expect that all these clock changes should go through Mike.=

If I am wrong please let me know.

Thanks,
Michal


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec9300=
92:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.xilinx.com/linux-xlnx.git tags/zynq-clk-fixes-for-3.11

for you to fetch changes up to 97d58aef394831f6f0583653de29e03886a0e09e:

  clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes (2013-07-=
17 08:36:53 +0200)

----------------------------------------------------------------
arm: Xilinx Zynq clock fixes for v3.11

- Fix watchdog clock registration
- Fix gem clock propagation

----------------------------------------------------------------
Soren Brinkmann (2):
      clk/zynq/clkc: Add dedicated spinlock for the SWDT
      clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes

 drivers/clk/zynq/clkc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--1to5Skg0gktRk4MF1qcMUmXNjv4JNxSXq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHyZxYACgkQykllyylKDCFI2gCfQMPXGpstijqZZExh3et+bBmB
yWYAnA8z0X/CQhWlXbsK+/kc0Tgvn/Cn
=+Smk
-----END PGP SIGNATURE-----

--1to5Skg0gktRk4MF1qcMUmXNjv4JNxSXq--
