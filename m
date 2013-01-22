Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3AVSbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:31:09 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34162 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab3AVSa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:30:59 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/20] drivers/net/ethernet/seeq: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 22 Jan 2013 10:30:29 -0800
Message-Id: <1358879444-25834-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358879444-25834-1-git-send-email-keescook@chromium.org>
References: <1358879444-25834-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: NetDev <netdev@vger.kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/seeq/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/seeq/Kconfig b/drivers/net/ethernet/seeq/Kconfig
index 29f1853..2366fa0 100644
--- a/drivers/net/ethernet/seeq/Kconfig
+++ b/drivers/net/ethernet/seeq/Kconfig
@@ -6,7 +6,6 @@ config NET_VENDOR_SEEQ
 	bool "SEEQ devices"
 	default y
 	depends on HAS_IOMEM
-	depends on (ARM && ARCH_ACORN) || SGI_HAS_SEEQ || EXPERIMENTAL
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -27,8 +26,7 @@ config ARM_ETHER3
 	  should say Y to this option if you wish to use it with Linux.
 
 config SEEQ8005
-	tristate "SEEQ8005 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "SEEQ8005 support"
 	---help---
 	  This is a driver for the SEEQ 8005 network (Ethernet) card.  If this
 	  is for you, read the Ethernet-HOWTO, available from
-- 
1.7.9.5

