Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3AQDIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:08:09 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57541 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758696Ab3AQCyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:43 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 69/86] drivers/vlynq: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:01 -0800
Message-Id: <1358391258-1771-70-git-send-email-keescook@chromium.org>
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

Cc: Florian Fainelli <florian@openwrt.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/vlynq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
index d874b4f..e011620 100644
--- a/drivers/vlynq/Kconfig
+++ b/drivers/vlynq/Kconfig
@@ -1,5 +1,5 @@
 menu "TI VLYNQ"
-	depends on AR7 && EXPERIMENTAL
+	depends on AR7
 
 config VLYNQ
 	bool "TI VLYNQ bus support"
-- 
1.7.9.5

