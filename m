Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030450Ab3E3K3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:29:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51825 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968055Ab3E3K2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:28:23 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        renner@efe-gmbh.de, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH v2 5/6] net: emaclite: Enable emaclite for Xilinx Arm Zynq platform
Date: Thu, 30 May 2013 12:28:07 +0200
Message-Id: <ca2770c39bc119d754854d978fada9931c48719f.1369909618.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1369909618.git.michal.simek@xilinx.com>
References: <cover.1369909618.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1369909618.git.michal.simek@xilinx.com>
References: <cover.1369909618.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-5499-1369909700-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-5499-1369909700-0001

Enable emaclite for Xilinx ARM Zynq platform.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2: None

 drivers/net/ethernet/xilinx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 122d60c..7b90a5e 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE
+	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -20,7 +20,7 @@ if NET_VENDOR_XILINX

 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
-	depends on (PPC32 || MICROBLAZE)
+	depends on (PPC32 || MICROBLAZE || ARCH_ZYNQ)
 	select PHYLIB
 	---help---
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
--
1.8.2.3


--=_mimegpg-monstr-desktop-5499-1369909700-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGnKcQACgkQykllyylKDCEt5gCcCw6SFy6Jz1BJwoGJFpoGhh//
HzkAnjq3JIpOGx84laWrprYKjjvibGFq
=kCAu
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-5499-1369909700-0001--
