Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3LRJmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:42:36 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47887 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3LRJmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:42:33 -0500
Message-ID: <52B16E05.5080404@monstr.eu>
Date: Wed, 18 Dec 2013 10:42:29 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-mmc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Xilinx Zynq mmc changes for v3.14
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CLTDATHIDmIKjPAMhIkUftalAJIpWT7ia"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CLTDATHIDmIKjPAMhIkUftalAJIpWT7ia
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Soren and I are trying to reach you regarding Arasan driver we sent to ma=
iling list
for review. There are no complains about this version 3 that's why I have=
 added
to our repo and sending you this pull request.

Patches:
http://lkml.org/lkml/2013/12/2/413
http://lkml.org/lkml/2013/12/2/424

Thanks for pulling these changes to your tree.

This driver was also requested to add LTSI that's why I am CC'ing Greg.

Thanks,
Michal


The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef608=
39:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.xilinx.com/linux-xlnx.git tags/zynq-mmc-for-3.14

for you to fetch changes up to da48f3cfb6d5dc0859dc4b77a145df5c749d2ea4:

  arm: dt: zynq: Add SDHCI nodes (2013-12-18 10:27:50 +0100)

----------------------------------------------------------------
arm: Xilinx Zynq mmc patches for v3.14

- Add support for Arasan SDHCI
- Add nodes to DTS files

----------------------------------------------------------------
Soren Brinkmann (2):
      mmc: arasan: Add driver for Arasan SDHCI
      arm: dt: zynq: Add SDHCI nodes

 Documentation/devicetree/bindings/mmc/arasan,sdhci.txt |  27 +++++++++++=
++++++++++
 MAINTAINERS                                            |   1 +
 arch/arm/boot/dts/zynq-7000.dtsi                       |  20 +++++++++++=
+++++
 arch/arm/boot/dts/zynq-zc702.dts                       |   4 ++++
 arch/arm/boot/dts/zynq-zc706.dts                       |   4 ++++
 arch/arm/boot/dts/zynq-zed.dts                         |   4 ++++
 drivers/mmc/host/Kconfig                               |  12 ++++++++++
 drivers/mmc/host/Makefile                              |   1 +
 drivers/mmc/host/sdhci-of-arasan.c                     | 224 +++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++
 9 files changed, 297 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/arasan,sdhci.tx=
t
 create mode 100644 drivers/mmc/host/sdhci-of-arasan.c


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--CLTDATHIDmIKjPAMhIkUftalAJIpWT7ia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKxbgUACgkQykllyylKDCGQmwCfeLeKLq8xVkQNCPvISzr0F8n3
vscAnjT2RG4ylk1IYt4TSDliMvVFeXri
=PU3Y
-----END PGP SIGNATURE-----

--CLTDATHIDmIKjPAMhIkUftalAJIpWT7ia--
