Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3EaM4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:56:38 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63719 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3EaM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:56:15 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 8/8] video: xilinxfb: Use driver for Xilinx ARM Zynq
Date: Fri, 31 May 2013 14:55:38 +0200
Message-Id: <f28173fdd2b8944a6ea04e4d72278b80cdcf5eee.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8209-1370004971-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8209-1370004971-0001

From: Michal Simek <monstr@monstr.eu>

Enable this driver for all Xilinx platforms.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
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


--=_mimegpg-monstr-desktop-8209-1370004971-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGonesACgkQykllyylKDCF5GwCdFM7J0sHuqzkA74vHZcjjmkuP
pbsAnRlC2rWuAZuJToCjHpCo5CWXfe3Q
=447P
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8209-1370004971-0001--
