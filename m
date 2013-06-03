Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3FCKN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:13:28 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62883 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3FCKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:13:26 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v4 0/7] xilinxfb changes
Date: Mon,  3 Jun 2013 12:13:15 +0200
Message-Id: <cover.1370254386.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9717-1370254402-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9717-1370254402-0001

Hi,

I have done more changes in the driver to support probing
on little and big endian system where detection is done
directly on the hardware.
I have also done some cleanups to get it to the better shape.

Thanks for your review,
Michal

Changes in v4:
- Acked by Arnd
- Remove "video: xilinxfb: Fix sparse warnings"
  patch because it is trying to fix incorrect API
  usage and sparse should warn about it.

Changes in v3:
- fix commit message
- Remove out_be IO name from function name
- Change patch subject from "Do not use out_be32 IO function"
  to "Do not name out_be32 in function name"
- New patch in this patchset based on discussions
- New patch in this patchset based on discussions
- New patch in this patchset
- New patch in this patchset based on discussions

Changes in v2:
- use of_property_read_u32 helper function

Michal Simek (7):
  video: xilinxfb: Fix OF probing on little-endian systems
  video: xilinxfb: Do not name out_be32 in function name
  video: xilinxfb: Rename PLB_ACCESS_FLAG to BUS_ACCESS_FLAG
  video: xilinxfb: Use drvdata->regs_phys instead of physaddr
  video: xilinxfb: Group bus initialization
  video: xilinxfb: Add support for little endian accesses
  video: xilinxfb: Use driver for Xilinx ARM Zynq

 drivers/video/Kconfig    |   2 +-
 drivers/video/xilinxfb.c | 135 +++++++++++++++++++++++------------------------
 2 files changed, 68 insertions(+), 69 deletions(-)

--
1.8.2.3


--=_mimegpg-monstr-desktop-9717-1370254402-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsbEIACgkQykllyylKDCHRkACfT0eCE/iqClD1fmcYOkHJEwtV
1GMAn0GQr+VZqVPi0NzxHHLVMXf07O3V
=5uOg
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9717-1370254402-0001--
