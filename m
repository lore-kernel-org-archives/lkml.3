Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3AVSbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:31:24 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54562 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab3AVSbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:31:19 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 14/20] drivers/net/wireless/b43: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 22 Jan 2013 10:30:38 -0800
Message-Id: <1358879444-25834-15-git-send-email-keescook@chromium.org>
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

CC: Stefano Brivio <stefano.brivio@polimi.it>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: NetDev <netdev@vger.kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/b43/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 7a28d21..287c6b6 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -78,8 +78,8 @@ config B43_PCMCIA
 	  If unsure, say N.
 
 config B43_SDIO
-	bool "Broadcom 43xx SDIO device support (EXPERIMENTAL)"
-	depends on B43 && SSB_SDIOHOST_POSSIBLE && EXPERIMENTAL
+	bool "Broadcom 43xx SDIO device support"
+	depends on B43 && SSB_SDIOHOST_POSSIBLE
 	select SSB_SDIOHOST
 	---help---
 	  Broadcom 43xx device support for Soft-MAC SDIO devices.
@@ -109,8 +109,8 @@ config B43_PIO
 	default y
 
 config B43_PHY_N
-	bool "Support for 802.11n (N-PHY) devices (EXPERIMENTAL)"
-	depends on B43 && EXPERIMENTAL
+	bool "Support for 802.11n (N-PHY) devices"
+	depends on B43
 	---help---
 	  Support for the N-PHY.
 
@@ -130,8 +130,8 @@ config B43_PHY_LP
 	  (802.11a support is optional, and currently disabled).
 
 config B43_PHY_HT
-	bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
-	depends on B43 && EXPERIMENTAL
+	bool "Support for HT-PHY (high throughput) devices"
+	depends on B43
 	---help---
 	  Support for the HT-PHY.
 
-- 
1.7.9.5

