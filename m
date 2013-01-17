Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab3AQDOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:14:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37548 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263Ab3AQCyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:36 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 40/86] drivers/gpio: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:32 -0800
Message-Id: <1358391258-1771-41-git-send-email-keescook@chromium.org>
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

CC: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 682de75..4c54586 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -66,7 +66,7 @@ config DEBUG_GPIO
 
 config GPIO_SYSFS
 	bool "/sys/class/gpio/... (sysfs interface)"
-	depends on SYSFS && EXPERIMENTAL
+	depends on SYSFS
 	help
 	  Say Y here to add a sysfs interface for GPIOs.
 
-- 
1.7.9.5

