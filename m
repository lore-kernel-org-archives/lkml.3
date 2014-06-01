Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbaFAMSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:04 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61525 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:17:59 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/26] staging: rtl8188eu: Remove header file rtw_version.h
Date: Sun,  1 Jun 2014 17:46:29 +0530
Message-Id: <1401625013-11208-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c      |    1 -
 drivers/staging/rtl8188eu/include/rtw_debug.h   |    2 +-
 drivers/staging/rtl8188eu/include/rtw_version.h |    1 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c  |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c     |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c     |    1 -
 6 files changed, 1 insertion(+), 6 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_version.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index 2beb269..995b74b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -20,7 +20,6 @@
 #define _RTW_DEBUG_C_
 
 #include <rtw_debug.h>
-#include <rtw_version.h>
 
 int proc_get_drv_version(char *page, char **start,
 			  off_t offset, int count,
diff --git a/drivers/staging/rtl8188eu/include/rtw_debug.h b/drivers/staging/rtl8188eu/include/rtw_debug.h
index ae05141..a38616e 100644
--- a/drivers/staging/rtl8188eu/include/rtw_debug.h
+++ b/drivers/staging/rtl8188eu/include/rtw_debug.h
@@ -23,7 +23,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-
+#define DRIVERVERSION	"v4.1.4_6773.20130222"
 #define _drv_always_			1
 #define _drv_emerg_			2
 #define _drv_alert_			3
diff --git a/drivers/staging/rtl8188eu/include/rtw_version.h b/drivers/staging/rtl8188eu/include/rtw_version.h
deleted file mode 100644
index 6d2d52c..0000000
--- a/drivers/staging/rtl8188eu/include/rtw_version.h
+++ /dev/null
@@ -1 +0,0 @@
-#define DRIVERVERSION	"v4.1.4_6773.20130222"
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 97f8b3e..897f03f 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -30,7 +30,6 @@
 #include <rtw_ioctl_set.h>
 #include <rtw_mp_ioctl.h>
 #include <usb_ops.h>
-#include <rtw_version.h>
 #include <rtl8188e_hal.h>
 
 #include <rtw_mp.h>
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 6fe32f0..a220c57 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -25,7 +25,6 @@
 #include <recv_osdep.h>
 #include <hal_intf.h>
 #include <rtw_ioctl.h>
-#include <rtw_version.h>
 
 #include <usb_osintf.h>
 #include <usb_hal.h>
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 05dce99..d17218f 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -24,7 +24,6 @@
 #include <recv_osdep.h>
 #include <xmit_osdep.h>
 #include <hal_intf.h>
-#include <rtw_version.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <osdep_intf.h>
-- 
1.7.10.4

