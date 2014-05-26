Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaEZQHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62667 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:07 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/24] staging: rtl8188eu: Remove unused macros and enum defined in odm_types.h
Date: Mon, 26 May 2014 21:35:27 +0530
Message-Id: <1401120339-23667-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_types.h |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_types.h b/drivers/staging/rtl8188eu/include/odm_types.h
index 78ee2ba..c1355b9 100644
--- a/drivers/staging/rtl8188eu/include/odm_types.h
+++ b/drivers/staging/rtl8188eu/include/odm_types.h
@@ -20,31 +20,13 @@
 #ifndef __ODM_TYPES_H__
 #define __ODM_TYPES_H__
 
-/*  */
-/*  Define Different SW team support */
-/*  */
-#define	ODM_AP			0x01	 /* BIT0 */
-#define	ODM_ADSL		0x02	/* BIT1 */
 #define	ODM_CE			0x04	/* BIT2 */
-#define	ODM_MP			0x08	/* BIT3 */
-
-#define		RT_PCI_INTERFACE				1
-#define		RT_USB_INTERFACE				2
-#define		RT_SDIO_INTERFACE				3
 
 enum HAL_STATUS {
 	HAL_STATUS_SUCCESS,
 	HAL_STATUS_FAILURE,
 };
 
-enum RT_SPINLOCK_TYPE {
-	RT_TEMP = 1,
-};
-
-#include <basic_types.h>
-
-#define DEV_BUS_TYPE	RT_USB_INTERFACE
-
 #define SET_TX_DESC_ANTSEL_A_88E(__pTxDesc, __Value)			\
 	SET_BITS_TO_LE_4BYTE(__pTxDesc+8, 24, 1, __Value)
 #define SET_TX_DESC_ANTSEL_B_88E(__pTxDesc, __Value)			\
@@ -52,11 +34,4 @@ enum RT_SPINLOCK_TYPE {
 #define SET_TX_DESC_ANTSEL_C_88E(__pTxDesc, __Value)			\
 	SET_BITS_TO_LE_4BYTE(__pTxDesc+28, 29, 1, __Value)
 
-/* define useless flag to avoid compile warning */
-#define	USE_WORKITEM			0
-#define		FOR_BRAZIL_PRETEST	0
-#define	BT_30_SUPPORT			0
-#define   FPGA_TWO_MAC_VERIFICATION	0
-
-
 #endif /*  __ODM_TYPES_H__ */
-- 
1.7.10.4

