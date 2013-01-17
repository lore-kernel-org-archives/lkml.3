Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3AQCyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:54 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37089 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774Ab3AQCyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:52 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 16/86] drivers/net/wireless/p54: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:08 -0800
Message-Id: <1358391258-1771-17-git-send-email-keescook@chromium.org>
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

CC: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/p54/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 0ec55b5..15ea36b 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -1,6 +1,6 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211
 	select FW_LOADER
 	select CRC_CCITT
 	---help---
-- 
1.7.9.5

