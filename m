Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaAVDBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:01:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48017 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaAVDBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:01:34 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] uapi: dn: pull in ioctl.h header
Date: Tue, 21 Jan 2014 22:01:33 -0500
Message-Id: <1390359693-11700-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header uses _IOW/_IOR defines but doesn't include ioctl.h for it.
If you try to use this w/out including ioctl.h yourself, it can fail
to build, so add the explicit include.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/uapi/linux/dn.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dn.h b/include/uapi/linux/dn.h
index 5fbdd3d..4295c74 100644
--- a/include/uapi/linux/dn.h
+++ b/include/uapi/linux/dn.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DN_H
 #define _LINUX_DN_H
 
+#include <linux/ioctl.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
-- 
1.8.4.3

