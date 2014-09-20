Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaITO0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:26:37 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59523 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbaITO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:26:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/13] staging: rtl8188eu: Remove unused header file odm_RegDefine11AC.h
Date: Sat, 20 Sep 2014 19:55:48 +0530
Message-Id: <1411223160-17292-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 .../staging/rtl8188eu/include/odm_RegDefine11AC.h  |   54 --------------------
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    1 -
 2 files changed, 55 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/odm_RegDefine11AC.h

diff --git a/drivers/staging/rtl8188eu/include/odm_RegDefine11AC.h b/drivers/staging/rtl8188eu/include/odm_RegDefine11AC.h
deleted file mode 100644
index f08775c..0000000
--- a/drivers/staging/rtl8188eu/include/odm_RegDefine11AC.h
+++ /dev/null
@@ -1,54 +0,0 @@
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
-#ifndef	__ODM_REGDEFINE11AC_H__
-#define __ODM_REGDEFINE11AC_H__
-
-/* 2 RF REG LIST */
-
-
-
-/* 2 BB REG LIST */
-/* PAGE 8 */
-/* PAGE 9 */
-#define	ODM_REG_OFDM_FA_RST_11AC		0x9A4
-/* PAGE A */
-#define	ODM_REG_CCK_CCA_11AC				0xA0A
-#define	ODM_REG_CCK_FA_RST_11AC			0xA2C
-#define	ODM_REG_CCK_FA_11AC				0xA5C
-/* PAGE C */
-#define	ODM_REG_IGI_A_11AC				0xC50
-/* PAGE E */
-#define	ODM_REG_IGI_B_11AC				0xE50
-/* PAGE F */
-#define	ODM_REG_OFDM_FA_11AC			0xF48
-
-
-/* 2 MAC REG LIST */
-
-
-
-
-/* DIG Related */
-#define	ODM_BIT_IGI_11AC				0xFFFFFFFF
-
-
-
-#endif
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index a8537bf..0f236da 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -37,7 +37,6 @@
 #include "odm.h"
 #include "odm_HWConfig.h"
 #include "odm_debug.h"
-#include "odm_RegDefine11AC.h"
 #include "odm_RegDefine11N.h"
 
 #include "Hal8188ERateAdaptive.h"/* for  RA,Power training */
-- 
1.7.10.4

