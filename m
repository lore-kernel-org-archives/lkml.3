Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3GXHLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:11:52 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53510 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3GXHLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:11:50 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] drivers: net: allwinner: Fix Kconfig indentation
Date: Wed, 24 Jul 2013 09:11:37 +0200
Message-Id: <1374649897-25952-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/net/ethernet/allwinner/Kconfig | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/Kconfig b/drivers/net/ethernet/allwinner/Kconfig
index 53ad213..cf7aa24 100644
--- a/drivers/net/ethernet/allwinner/Kconfig
+++ b/drivers/net/ethernet/allwinner/Kconfig
@@ -3,19 +3,20 @@
 #
 
 config NET_VENDOR_ALLWINNER
-       bool "Allwinner devices"
-       default y
-       depends on ARCH_SUNXI
-       ---help---
-         If you have a network (Ethernet) card belonging to this
-	 class, say Y and read the Ethernet-HOWTO, available from
-	 <http://www.tldp.org/docs.html#howto>.
+	bool "Allwinner devices"
+	default y
 
-	 Note that the answer to this question doesn't directly
-	 affect the kernel: saying N will just cause the configurator
-	 to skip all the questions about Allwinner cards. If you say Y,
-	 you will be asked for your specific card in the following
-	 questions.
+	depends on ARCH_SUNXI
+	---help---
+	  If you have a network (Ethernet) card belonging to this
+	  class, say Y and read the Ethernet-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  Note that the answer to this question doesn't directly
+	  affect the kernel: saying N will just cause the configurator
+	  to skip all the questions about Allwinner cards. If you say Y,
+	  you will be asked for your specific card in the following
+	  questions.
 
 if NET_VENDOR_ALLWINNER
 
-- 
1.8.3.2

