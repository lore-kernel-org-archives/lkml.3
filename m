Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3AQDJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:09:44 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58598 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab3AQCym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:42 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 71/86] fs/adfs: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:03 -0800
Message-Id: <1358391258-1771-72-git-send-email-keescook@chromium.org>
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

Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/adfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/adfs/Kconfig b/fs/adfs/Kconfig
index e55182a..c5a7787 100644
--- a/fs/adfs/Kconfig
+++ b/fs/adfs/Kconfig
@@ -1,6 +1,6 @@
 config ADFS_FS
-	tristate "ADFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "ADFS file system support"
+	depends on BLOCK
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
-- 
1.7.9.5

