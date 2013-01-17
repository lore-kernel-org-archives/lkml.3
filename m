Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3AQDN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:13:26 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41159 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557Ab3AQCyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:38 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tim Waugh <tim@cyberelk.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 38/86] drivers/block/paride: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:30 -0800
Message-Id: <1358391258-1771-39-git-send-email-keescook@chromium.org>
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

CC: Tim Waugh <tim@cyberelk.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/paride/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/paride/Kconfig b/drivers/block/paride/Kconfig
index 28cf308..efefb5a 100644
--- a/drivers/block/paride/Kconfig
+++ b/drivers/block/paride/Kconfig
@@ -205,8 +205,8 @@ config PARIDE_EPAT
 	  support.
 
 config PARIDE_EPATC8
-	bool "Support c7/c8 chips (EXPERIMENTAL)"
-	depends on PARIDE_EPAT && EXPERIMENTAL
+	bool "Support c7/c8 chips"
+	depends on PARIDE_EPAT
 	help
 	  This option enables support for the newer Shuttle EP1284 (aka c7 and
 	  c8) chip. You need this if you are using any recent Imation SuperDisk
-- 
1.7.9.5

