Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaDTIrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:47:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36789 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaDTIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:47:34 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/10] staging: rtl8188eu: Remove empty header file
Date: Sun, 20 Apr 2014 14:17:09 +0530
Message-Id: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drv_types_linux.h is empty, so remove the header file and its
reference.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h      |    1 -
 .../staging/rtl8188eu/include/drv_types_linux.h    |   24 --------------------
 2 files changed, 25 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/drv_types_linux.h

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 936c196..10cc1a1 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -31,7 +31,6 @@
 
 #include <osdep_service.h>
 #include <wlan_bssdef.h>
-#include <drv_types_linux.h>
 #include <rtw_ht.h>
 #include <rtw_cmd.h>
 #include <rtw_xmit.h>
diff --git a/drivers/staging/rtl8188eu/include/drv_types_linux.h b/drivers/staging/rtl8188eu/include/drv_types_linux.h
deleted file mode 100644
index 812b744..0000000
--- a/drivers/staging/rtl8188eu/include/drv_types_linux.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-#ifndef __DRV_TYPES_LINUX_H__
-#define __DRV_TYPES_LINUX_H__
-
-
-#endif
-- 
1.7.10.4

