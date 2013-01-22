Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3AVSfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:35:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45600 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3AVSbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:31:02 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 02/20] drivers/net/ethernet/icplus: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 22 Jan 2013 10:30:26 -0800
Message-Id: <1358879444-25834-3-git-send-email-keescook@chromium.org>
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

