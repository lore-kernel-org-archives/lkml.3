Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab3AQDBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:01:34 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56680 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab3AQCzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:00 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 15/86] drivers/net/wireless/ipw2x00: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:07 -0800
Message-Id: <1358391258-1771-16-git-send-email-keescook@chromium.org>
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

CC: Stanislav Yakovlev <stas.yakovlev@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ipw2x00/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 2715b10..91c0cb3 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -137,7 +137,7 @@ config IPW2200_PROMISCUOUS
 
 config IPW2200_QOS
         bool "Enable QoS support"
-        depends on IPW2200 && EXPERIMENTAL
+        depends on IPW2200
 
 config IPW2200_DEBUG
 	bool "Enable full debugging output in IPW2200 module."
-- 
1.7.9.5

