Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaBLRke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:40:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44898 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBLRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:40:33 -0500
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH] staging: rtl8188eu: remove unused header files
Date: Wed, 12 Feb 2014 23:10:16 +0530
Message-Id: <1392226816-14318-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove h2clbk.h and nic_spec.h header files.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/h2clbk.h   |   35 --------------------
 drivers/staging/rtl8188eu/include/nic_spec.h |   44 --------------------------
 2 files changed, 79 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/h2clbk.h
 delete mode 100644 drivers/staging/rtl8188eu/include/nic_spec.h

diff --git a/drivers/staging/rtl8188eu/include/h2clbk.h b/drivers/staging/rtl8188eu/include/h2clbk.h
deleted file mode 100644
index e595030..0000000
--- a/drivers/staging/rtl8188eu/include/h2clbk.h
+++ /dev/null
@@ -1,35 +0,0 @@
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
-
-
-#define _H2CLBK_H_
-
-
-#include <rtl8711_spec.h>
-#include <TypeDef.h>
-
-
-void _lbk_cmd(struct adapter *adapter);
-
-void _lbk_rsp(struct adapter *adapter);
-
-void _lbk_evt(IN struct adapter *adapter);
-
-void h2c_event_callback(unsigned char *dev, unsigned char *pbuf);
diff --git a/drivers/staging/rtl8188eu/include/nic_spec.h b/drivers/staging/rtl8188eu/include/nic_spec.h
deleted file mode 100644
index d422447..0000000
--- a/drivers/staging/rtl8188eu/include/nic_spec.h
+++ /dev/null
@@ -1,44 +0,0 @@
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
-
-
-#ifndef __NIC_SPEC_H__
-#define __NIC_SPEC_H__
-
-#define RTL8711_MCTRL_		(0x20000)
-#define RTL8711_UART_		(0x30000)
-#define RTL8711_TIMER_		(0x40000)
-#define RTL8711_FINT_		(0x50000)
-#define RTL8711_HINT_		(0x50000)
-#define RTL8711_GPIO_		(0x60000)
-#define RTL8711_WLANCTRL_	(0x200000)
-#define RTL8711_WLANFF_		(0xe00000)
-#define RTL8711_HCICTRL_	(0x600000)
-#define RTL8711_SYSCFG_		(0x620000)
-#define RTL8711_SYSCTRL_	(0x620000)
-#define RTL8711_MCCTRL_		(0x020000)
-
-
-#include <rtl8711_regdef.h>
-
-#include <rtl8711_bitdef.h>
-
-
-#endif /*  __RTL8711_SPEC_H__ */
--
1.7.10.4

