Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330AbaE2RyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:54:16 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54872 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaE2RyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:54:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/18] staging: rtl8188eu: Remove empty files rtl8188e_sreset.[c|h]
Date: Thu, 29 May 2014 23:20:53 +0530
Message-Id: <1401385858-28722-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile                 |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c    |   25 -----------------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |    3 +--
 .../staging/rtl8188eu/include/rtl8188e_sreset.h    |   28 --------------------
 4 files changed, 1 insertion(+), 56 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
 delete mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_sreset.h

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 6a138ff..260c635 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -44,7 +44,6 @@ r8188eu-y :=				\
 		hal/rtl8188e_phycfg.o	\
 		hal/rtl8188e_rf6052.o	\
 		hal/rtl8188e_rxdesc.o	\
-		hal/rtl8188e_sreset.o	\
 		hal/rtl8188e_xmit.o	\
 		hal/rtl8188eu_led.o	\
 		hal/rtl8188eu_recv.o	\
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
deleted file mode 100644
index f907fe0..0000000
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
+++ /dev/null
@@ -1,25 +0,0 @@
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
-#define _RTL8188E_SRESET_C_
-
-#include <rtl8188e_sreset.h>
-#include <rtl8188e_hal.h>
-
-
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index fe3b454..c7fef7a 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -31,9 +31,8 @@
 #include "rtl8188e_xmit.h"
 #include "rtl8188e_cmd.h"
 #include "Hal8188EPwrSeq.h"
-#include "rtl8188e_sreset.h"
 #include "rtw_efuse.h"
-
+#include "rtw_sreset.h"
 #include "odm_precomp.h"
 
 /*  Fw Array */
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
deleted file mode 100644
index cade6d7..0000000
--- a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
+++ /dev/null
@@ -1,28 +0,0 @@
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
-#ifndef _RTL8188E_SRESET_H_
-#define _RTL8188E_SRESET_H_
-
-#include <osdep_service.h>
-#include <drv_types.h>
-#include <rtw_sreset.h>
-
-
-#endif
-- 
1.7.10.4

