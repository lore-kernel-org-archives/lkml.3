Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbaGBQw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37057 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaGBQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:54 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 28/48] staging: rtl8188eu: Remove header file cmd_osdep.h
Date: Wed,  2 Jul 2014 22:17:24 +0530
Message-Id: <1404319664-8327-28-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmd_osdep.h is not required.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c      |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c  |    1 -
 drivers/staging/rtl8188eu/include/cmd_osdep.h |   31 -------------------------
 3 files changed, 33 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/cmd_osdep.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 651d809..5a1ee87 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -22,7 +22,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <recv_osdep.h>
-#include <cmd_osdep.h>
 #include <mlme_osdep.h>
 #include <rtw_mlme_ext.h>
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 6ad3bd4..023a3d8 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -22,7 +22,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <recv_osdep.h>
-#include <cmd_osdep.h>
 #include <mlme_osdep.h>
 #include <rtw_ioctl_set.h>
 
diff --git a/drivers/staging/rtl8188eu/include/cmd_osdep.h b/drivers/staging/rtl8188eu/include/cmd_osdep.h
deleted file mode 100644
index 7a93e1d..0000000
--- a/drivers/staging/rtl8188eu/include/cmd_osdep.h
+++ /dev/null
@@ -1,31 +0,0 @@
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
-#ifndef __CMD_OSDEP_H_
-#define __CMD_OSDEP_H_
-
-#include <osdep_service.h>
-#include <drv_types.h>
-
-extern int _rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
-extern void _rtw_free_cmd_priv(struct cmd_priv *pcmdpriv);
-extern int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj);
-extern struct cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue);
-
-#endif
-- 
1.7.10.4

