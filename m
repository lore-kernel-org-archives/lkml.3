Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab3AQDCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:02:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47476 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758885Ab3AQCyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:53 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Alex Dubov <oakad@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 53/86] drivers/memstick: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:45 -0800
Message-Id: <1358391258-1771-54-git-send-email-keescook@chromium.org>
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

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/memstick/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/Kconfig b/drivers/memstick/Kconfig
index f0ca41c..1314605 100644
--- a/drivers/memstick/Kconfig
+++ b/drivers/memstick/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig MEMSTICK
-	tristate "Sony MemoryStick card support (EXPERIMENTAL)"
+	tristate "Sony MemoryStick card support"
 	help
 	  Sony MemoryStick is a proprietary storage/extension card protocol.
 
-- 
1.7.9.5

