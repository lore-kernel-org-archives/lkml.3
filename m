Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbaE2Rym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:54:42 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61266 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965348AbaE2Ryj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:54:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/18] staging: rtl8188eu: Remove Hal8188EReg.h file
Date: Thu, 29 May 2014 23:20:56 +0530
Message-Id: <1401385858-28722-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver doesn't need Hal8188EReg.h file.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/Hal8188EReg.h |   46 -----------------------
 drivers/staging/rtl8188eu/include/odm_precomp.h |    1 -
 2 files changed, 47 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/Hal8188EReg.h

diff --git a/drivers/staging/rtl8188eu/include/Hal8188EReg.h b/drivers/staging/rtl8188eu/include/Hal8188EReg.h
deleted file mode 100644
index d880b0c..0000000
--- a/drivers/staging/rtl8188eu/include/Hal8188EReg.h
+++ /dev/null
@@ -1,46 +0,0 @@
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
-/*  */
-/*  File Name: Hal8188EReg.h */
-/*  */
-/*  Description: */
-/*  */
-/*  This file is for RTL8188E register definition. */
-/*  */
-/*  */
-/*  */
-#ifndef	__HAL_8188E_REG_H__
-#define __HAL_8188E_REG_H__
-
-/*  */
-/*  Register Definition */
-/*  */
-#define TRX_ANTDIV_PATH             0x860
-#define RX_ANTDIV_PATH              0xb2c
-#define	ODM_R_A_AGC_CORE1_8188E		0xc50
-
-
-/*  */
-/*  Bitmap Definition */
-/*  */
-#define	BIT_FA_RESET_8188E			BIT0
-
-
-#endif
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 2eb769b3..7cc2cc9 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -49,7 +49,6 @@
 #include "HalHWImg8188E_MAC.h"
 #include "HalHWImg8188E_RF.h"
 #include "HalHWImg8188E_BB.h"
-#include "Hal8188EReg.h"
 
 #include "odm_RegConfig8188E.h"
 #include "odm_RTL8188E.h"
-- 
1.7.10.4

