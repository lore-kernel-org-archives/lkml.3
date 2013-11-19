Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3KSOms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:48 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49659 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3KSOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:44 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/13] staging/lustre/libcfs: remove IOCTL_LIBCFS_TYPE
Date: Tue, 19 Nov 2013 22:38:42 +0800
Message-Id: <1384871927-8553-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |   66 ++++++++++----------
 .../lustre/include/linux/libcfs/linux/kp30.h       |    2 -
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
index 5be3679..315743e 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
@@ -110,41 +110,41 @@ struct libcfs_ioctl_handler {
 #define IOC_LIBCFS_TYPE		   'e'
 #define IOC_LIBCFS_MIN_NR		 30
 /* libcfs ioctls */
-#define IOC_LIBCFS_PANIC		   _IOWR('e', 30, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_CLEAR_DEBUG	     _IOWR('e', 31, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_MARK_DEBUG	      _IOWR('e', 32, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_LWT_CONTROL	     _IOWR('e', 33, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_LWT_SNAPSHOT	    _IOWR('e', 34, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_LWT_LOOKUP_STRING       _IOWR('e', 35, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_MEMHOG		  _IOWR('e', 36, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_PING_TEST	       _IOWR('e', 37, IOCTL_LIBCFS_TYPE)
+#define IOC_LIBCFS_PANIC		   _IOWR('e', 30, long)
+#define IOC_LIBCFS_CLEAR_DEBUG	     _IOWR('e', 31, long)
+#define IOC_LIBCFS_MARK_DEBUG	      _IOWR('e', 32, long)
+#define IOC_LIBCFS_LWT_CONTROL	     _IOWR('e', 33, long)
+#define IOC_LIBCFS_LWT_SNAPSHOT	    _IOWR('e', 34, long)
+#define IOC_LIBCFS_LWT_LOOKUP_STRING       _IOWR('e', 35, long)
+#define IOC_LIBCFS_MEMHOG		  _IOWR('e', 36, long)
+#define IOC_LIBCFS_PING_TEST	       _IOWR('e', 37, long)
 /* lnet ioctls */
-#define IOC_LIBCFS_GET_NI		  _IOWR('e', 50, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_FAIL_NID		_IOWR('e', 51, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_ADD_ROUTE	       _IOWR('e', 52, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_DEL_ROUTE	       _IOWR('e', 53, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_GET_ROUTE	       _IOWR('e', 54, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_NOTIFY_ROUTER	   _IOWR('e', 55, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_UNCONFIGURE	     _IOWR('e', 56, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_PORTALS_COMPATIBILITY   _IOWR('e', 57, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_LNET_DIST	       _IOWR('e', 58, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_CONFIGURE	       _IOWR('e', 59, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_TESTPROTOCOMPAT	 _IOWR('e', 60, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_PING		    _IOWR('e', 61, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_DEBUG_PEER	      _IOWR('e', 62, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_LNETST		  _IOWR('e', 63, IOCTL_LIBCFS_TYPE)
+#define IOC_LIBCFS_GET_NI		  _IOWR('e', 50, long)
+#define IOC_LIBCFS_FAIL_NID		_IOWR('e', 51, long)
+#define IOC_LIBCFS_ADD_ROUTE	       _IOWR('e', 52, long)
+#define IOC_LIBCFS_DEL_ROUTE	       _IOWR('e', 53, long)
+#define IOC_LIBCFS_GET_ROUTE	       _IOWR('e', 54, long)
+#define IOC_LIBCFS_NOTIFY_ROUTER	   _IOWR('e', 55, long)
+#define IOC_LIBCFS_UNCONFIGURE	     _IOWR('e', 56, long)
+#define IOC_LIBCFS_PORTALS_COMPATIBILITY   _IOWR('e', 57, long)
+#define IOC_LIBCFS_LNET_DIST	       _IOWR('e', 58, long)
+#define IOC_LIBCFS_CONFIGURE	       _IOWR('e', 59, long)
+#define IOC_LIBCFS_TESTPROTOCOMPAT	 _IOWR('e', 60, long)
+#define IOC_LIBCFS_PING		    _IOWR('e', 61, long)
+#define IOC_LIBCFS_DEBUG_PEER	      _IOWR('e', 62, long)
+#define IOC_LIBCFS_LNETST		  _IOWR('e', 63, long)
 /* lnd ioctls */
-#define IOC_LIBCFS_REGISTER_MYNID	  _IOWR('e', 70, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_CLOSE_CONNECTION	_IOWR('e', 71, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_PUSH_CONNECTION	 _IOWR('e', 72, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_GET_CONN		_IOWR('e', 73, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_DEL_PEER		_IOWR('e', 74, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_ADD_PEER		_IOWR('e', 75, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_GET_PEER		_IOWR('e', 76, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_GET_TXDESC	      _IOWR('e', 77, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_ADD_INTERFACE	   _IOWR('e', 78, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_DEL_INTERFACE	   _IOWR('e', 79, IOCTL_LIBCFS_TYPE)
-#define IOC_LIBCFS_GET_INTERFACE	   _IOWR('e', 80, IOCTL_LIBCFS_TYPE)
+#define IOC_LIBCFS_REGISTER_MYNID	  _IOWR('e', 70, long)
+#define IOC_LIBCFS_CLOSE_CONNECTION	_IOWR('e', 71, long)
+#define IOC_LIBCFS_PUSH_CONNECTION	 _IOWR('e', 72, long)
+#define IOC_LIBCFS_GET_CONN		_IOWR('e', 73, long)
+#define IOC_LIBCFS_DEL_PEER		_IOWR('e', 74, long)
+#define IOC_LIBCFS_ADD_PEER		_IOWR('e', 75, long)
+#define IOC_LIBCFS_GET_PEER		_IOWR('e', 76, long)
+#define IOC_LIBCFS_GET_TXDESC	      _IOWR('e', 77, long)
+#define IOC_LIBCFS_ADD_INTERFACE	   _IOWR('e', 78, long)
+#define IOC_LIBCFS_DEL_INTERFACE	   _IOWR('e', 79, long)
+#define IOC_LIBCFS_GET_INTERFACE	   _IOWR('e', 80, long)
 
 #define IOC_LIBCFS_MAX_NR			     80
 
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index d4c6716..69eefd5 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -175,8 +175,6 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
 
 /* ------------------------------------------------------------------ */
 
-#define IOCTL_LIBCFS_TYPE long
-
 #ifdef __CYGWIN__
 # ifndef BITS_PER_LONG
 #   define BITS_PER_LONG 64
-- 
1.7.9.5

