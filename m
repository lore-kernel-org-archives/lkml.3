Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3AQDIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:08:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36814 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673Ab3AQCym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:42 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 18/86] drivers/net/wireless/rtl818x: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:10 -0800
Message-Id: <1358391258-1771-19-git-send-email-keescook@chromium.org>
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

CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/rtl818x/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
index 17d80fe..3033217 100644
--- a/drivers/net/wireless/rtl818x/Kconfig
+++ b/drivers/net/wireless/rtl818x/Kconfig
@@ -3,7 +3,7 @@
 #
 config RTL8180
 	tristate "Realtek 8180/8185 PCI support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8180 and RTL8185 based cards.
-- 
1.7.9.5

