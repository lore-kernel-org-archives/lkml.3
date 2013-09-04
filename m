Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116Ab3IDHPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:15:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60182 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756366Ab3IDHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:15:53 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org
Cc: cesarb@cesarb.net, gregkh@linuxfoundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] cramfs: mark as obsolete
Date: Wed,  4 Sep 2013 09:15:49 +0200
Message-Id: <1378278949-3066-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Who needs cramfs when you have squashfs?
At least, we should warn people that cramfs
is obsolete.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS       | 2 +-
 fs/cramfs/Kconfig | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b32bc2..6218be0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2313,7 +2313,7 @@ F:	kernel/cpuset.c
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
-S:	Orphan
+S:	Orphan / Obsolete
 F:	Documentation/filesystems/cramfs.txt
 F:	fs/cramfs/
 
diff --git a/fs/cramfs/Kconfig b/fs/cramfs/Kconfig
index cd06466..15c36fe 100644
--- a/fs/cramfs/Kconfig
+++ b/fs/cramfs/Kconfig
@@ -1,5 +1,5 @@
 config CRAMFS
-	tristate "Compressed ROM file system support (cramfs)"
+	tristate "Compressed ROM file system support (cramfs) (OBSOLETE)"
 	depends on BLOCK
 	select ZLIB_INFLATE
 	help
@@ -16,4 +16,7 @@ config CRAMFS
 	  cramfs.  Note that the root file system (the one containing the
 	  directory /) cannot be compiled as a module.
 
+	  This filesystem is obsoleted by SquashFS, which is much better
+  	  in terms of performance and features.
+
 	  If unsure, say N.
-- 
1.8.1.2

