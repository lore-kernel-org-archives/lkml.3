Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3AQDKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:10:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60970 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab3AQCyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:41 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 74/86] fs/befs: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:06 -0800
Message-Id: <1358391258-1771-75-git-send-email-keescook@chromium.org>
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

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/befs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/befs/Kconfig b/fs/befs/Kconfig
index 7835d30..edc5cc2 100644
--- a/fs/befs/Kconfig
+++ b/fs/befs/Kconfig
@@ -1,6 +1,6 @@
 config BEFS_FS
-	tristate "BeOS file system (BeFS) support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "BeOS file system (BeFS) support (read only)"
+	depends on BLOCK
 	select NLS
 	help
 	  The BeOS File System (BeFS) is the native file system of Be, Inc's
-- 
1.7.9.5

