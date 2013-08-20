Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab3HTG4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:56:19 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:39417 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3HTGza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:30 -0400
Message-ID: <521312DF.1050001@monstr.eu>
Date: Tue, 20 Aug 2013 08:55:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: arm@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: clk: Xilinx Zynq changes for v3.12
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3FrS27IQlODCAA7Np0hbSf69jv6oa92mO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3FrS27IQlODCAA7Np0hbSf69jv6oa92mO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mike,

as we discussed with Kevin in my arm-soc pull request I should send
these two patches separately and directly to you.
I have rebased them on 3.11-rc2 which is the kernel version you have in
your clk-next branch. Thanks for pulling them.

Thanks,
Michal

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a=
4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.xilinx.com/linux-xlnx.git tags/zynq-clk-for-3.12

for you to fetch changes up to 353dc6c47d67c83f7cc20334f8deb251674e6864:

  clk/zynq/pll: Use #defines for fbdiv min/max values (2013-08-20 07:54:4=
1 +0200)

----------------------------------------------------------------
arm: Xilinx Zynq clock changes for v3.12

Just small two changes where the first fixes
documentation and the second improves
code readability.

----------------------------------------------------------------
Soren Brinkmann (2):
      clk/zynq/pll: Fix documentation for PLL register function
      clk/zynq/pll: Use #defines for fbdiv min/max values

 drivers/clk/zynq/pll.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--3FrS27IQlODCAA7Np0hbSf69jv6oa92mO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlITEt8ACgkQykllyylKDCEcoACfYwKCFnHxlThqtmyRJMiTecrt
8jcAn1wFmp8mN0ge0KCojqhk91vpthcA
=H6Dq
-----END PGP SIGNATURE-----

--3FrS27IQlODCAA7Np0hbSf69jv6oa92mO--
