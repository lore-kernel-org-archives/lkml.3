Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3FCKOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:14:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64922 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3FCKNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:13:47 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v4 7/7] video: xilinxfb: Use driver for Xilinx ARM Zynq
Date: Mon,  3 Jun 2013 12:13:22 +0200
Message-Id: <282ff667cd78aa58ebe93d856142e8446eb837c5.1370254386.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370254386.git.michal.simek@xilinx.com>
References: <cover.1370254386.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370254386.git.michal.simek@xilinx.com>
References: <cover.1370254386.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9811-1370254423-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9811-1370254423-0001

From: Michal Simek <monstr@monstr.eu>

Enable this driver for all Xilinx platforms.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v4:
- Remove "video: xilinxfb: Fix sparse warnings"
  patch because it is trying to fix incorrect API
  usage and sparse should warn about it.

Changes in v3: None
Changes in v2: None

 drivers/video/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2e937bd..2c301f8 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2188,7 +2188,7 @@ config FB_PS3_DEFAULT_SIZE_M

 config FB_XILINX
 	tristate "Xilinx frame buffer support"
-	depends on FB && (XILINX_VIRTEX || MICROBLAZE)
+	depends on FB && (XILINX_VIRTEX || MICROBLAZE || ARCH_ZYNQ)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
--
1.8.2.3


--=_mimegpg-monstr-desktop-9811-1370254423-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsbFcACgkQykllyylKDCFOkQCeMoft8MLrm+CaaEMwdXyORHyn
aXkAn0FfyrZ+YDaOELLYcf7loWBdJmX4
=wL2W
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9811-1370254423-0001--
