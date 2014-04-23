Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaDWGLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:11:24 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40115 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbaDWGLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:11:19 -0400
Message-ID: <53575983.3030508@monstr.eu>
Date: Wed, 23 Apr 2014 08:11:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [GIT PULL] serial: Cadence
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="e3rLcSE0UcFNNvF7TgBmlqXwWnkVF6uU3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e3rLcSE0UcFNNvF7TgBmlqXwWnkVF6uU3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Greg,

this is around for a while and I would like to close it.
I have applied patches 1-7 from v3.
Patches 8 and 9 should go through arm-soc tree and I will add them
to my zynq/dt branch.

Please apply these patches to your tree.
If this should go through different tree please let me know.

Thanks,
Michal


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6=
c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git tags/cadence-uart-for-3.16=


for you to fetch changes up to 05a06a30d212f76e7822ef1093fa002baac021a7:

  tty: xuartps: Rebrand driver as Cadence UART (2014-04-23 08:00:10 +0200=
)

----------------------------------------------------------------
tty: Cadence uart rebranding and cleanup

----------------------------------------------------------------
Michal Simek (2):
      tty: xuartps: Fix kernel-doc errors in the driver
      tty: xuartps: Initialize ports according to aliases

Soren Brinkmann (5):
      tty: xuartps: Clean up
      tty: xuartps: Print warning in clock notifier
      tty: xuartps: Refactor read-modify-writes
      tty: xuartps: Don't write IRQ disable register to enable interrupts=

      tty: xuartps: Rebrand driver as Cadence UART

 drivers/tty/serial/Kconfig         |    9 +-
 drivers/tty/serial/xilinx_uartps.c | 1129 ++++++++++++++++++++++++++++++=
+++++--------------------------------------
 include/uapi/linux/serial_core.h   |    2 +-
 3 files changed, 546 insertions(+), 594 deletions(-)


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--e3rLcSE0UcFNNvF7TgBmlqXwWnkVF6uU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXWYMACgkQykllyylKDCGbOwCffEnLBND0yDgcejbQ4wxpW2YY
+DEAn1T7ktyyS1Otfj0J4qTI44/4IETA
=4rZ4
-----END PGP SIGNATURE-----

--e3rLcSE0UcFNNvF7TgBmlqXwWnkVF6uU3--
