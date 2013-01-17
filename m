Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab3AQCyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:36 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52058 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263Ab3AQCyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:31 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/86] drivers/net/ethernet/icplus: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:52:54 -0800
Message-Id: <1358391258-1771-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/icplus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/icplus/Kconfig b/drivers/net/ethernet/icplus/Kconfig
index 3aff81d..5119ef1 100644
--- a/drivers/net/ethernet/icplus/Kconfig
+++ b/drivers/net/ethernet/icplus/Kconfig
@@ -4,7 +4,7 @@
 
 config IP1000
 	tristate "IP1000 Gigabit Ethernet support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select NET_CORE
 	select MII
 	---help---
-- 
1.7.9.5

