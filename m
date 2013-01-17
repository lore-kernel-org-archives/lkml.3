Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3AQDHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:07:20 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34414 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758392Ab3AQCyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:43 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 82/86] fs/nfsd: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:14 -0800
Message-Id: <1358391258-1771-83-git-send-email-keescook@chromium.org>
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

CC: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/nfsd/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 8df1ea4..430b687 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -65,8 +65,8 @@ config NFSD_V3_ACL
 	  If unsure, say N.
 
 config NFSD_V4
-	bool "NFS server support for NFS version 4 (EXPERIMENTAL)"
-	depends on NFSD && PROC_FS && EXPERIMENTAL
+	bool "NFS server support for NFS version 4"
+	depends on NFSD && PROC_FS
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
-- 
1.7.9.5

