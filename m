Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaIPEQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:16:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54088 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaIPEQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:16:32 -0400
From: Martin Kelly <martin@martingkelly.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com, mail@beyermatthias.de,
        linux-kernel@vger.kernel.org, Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH] Staging/bcm: Fix whitespace/comments in Ioctl.h
Date: Mon, 15 Sep 2014 21:16:15 -0700
Message-Id: <1410840975-24388-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup whitespace and comments in Ioctl.h in a few ways:
- > 80 character cleanup
- Comment clarification
- More consistent vertical alignment

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 drivers/staging/bcm/Ioctl.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/bcm/Ioctl.h b/drivers/staging/bcm/Ioctl.h
index 797f862..fa5f867 100644
--- a/drivers/staging/bcm/Ioctl.h
+++ b/drivers/staging/bcm/Ioctl.h
@@ -87,9 +87,9 @@ struct bcm_user_thread_req {
 #define IOCTL_BCM_FLASH2X_SECTION_WRITE		_IOW(BCM_IOCTL, 0x866, int)
 #define IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP	_IOR(BCM_IOCTL, 0x867, int)
 #define IOCTL_BCM_SET_ACTIVE_SECTION		_IOW(BCM_IOCTL, 0x868, int)
-#define	IOCTL_BCM_IDENTIFY_ACTIVE_SECTION	_IO(BCM_IOCTL, 0x869)
+#define IOCTL_BCM_IDENTIFY_ACTIVE_SECTION	_IO(BCM_IOCTL, 0x869)
 #define IOCTL_BCM_COPY_SECTION			_IOW(BCM_IOCTL, 0x870, int)
-#define	IOCTL_BCM_GET_FLASH_CS_INFO		_IOR(BCM_IOCTL, 0x871, int)
+#define IOCTL_BCM_GET_FLASH_CS_INFO		_IOR(BCM_IOCTL, 0x871, int)
 #define IOCTL_BCM_SELECT_DSD			_IOW(BCM_IOCTL, 0x872, int)
 #define IOCTL_BCM_NVM_RAW_READ			_IOR(BCM_IOCTL, 0x875, int)
 #define IOCTL_BCM_CNTRLMSG_MASK			_IOW(BCM_IOCTL, 0x874, int)
@@ -130,7 +130,7 @@ struct bcm_bulk_wrm_buffer {
 };
 
 enum bcm_flash2x_section_val {
-	NO_SECTION_VAL = 0, /* no section is chosen when absolute offset is given for RD/WR */
+	NO_SECTION_VAL = 0, /* no section chosen when absolute offset is given for RD/WR */
 	ISO_IMAGE1,
 	ISO_IMAGE2,
 	DSD0,
@@ -152,11 +152,11 @@ enum bcm_flash2x_section_val {
  * Structure used for READ/WRITE Flash Map2.x
  */
 struct bcm_flash2x_readwrite {
-	enum bcm_flash2x_section_val Section; /* which section has to be read/written */
-	u32 offset;	     /* Offset within Section. */
-	u32 numOfBytes;	     /* NOB from the offset */
+	enum bcm_flash2x_section_val Section; /* section to be read/written */
+	u32 offset; /* offset within section. */
+	u32 numOfBytes; /* number of bytes from the offset */
 	u32 bVerify;
-	void __user *pDataBuff;	     /* Buffer for reading/writing */
+	void __user *pDataBuff; /* buffer for reading/writing */
 };
 
 /*
@@ -207,20 +207,20 @@ struct bcm_time_elapsed {
 };
 
 enum {
-	WIMAX_IDX = 0,  /* To access WiMAX chip GPIO's for GPIO_MULTI_INFO or GPIO_MULTI_MODE */
-	HOST_IDX,	/* To access Host chip GPIO's for GPIO_MULTI_INFO or GPIO_MULTI_MODE */
+	WIMAX_IDX = 0, /* To access WiMAX chip GPIO's for GPIO_MULTI_INFO or GPIO_MULTI_MODE */
+	HOST_IDX, /* To access Host chip GPIO's for GPIO_MULTI_INFO or GPIO_MULTI_MODE */
 	MAX_IDX
 };
 
 struct bcm_gpio_multi_info {
 	unsigned int uiGPIOCommand; /* 1 for set and 0 for get */
-	unsigned int uiGPIOMask;    /* set the correspondig bit to 1 to access GPIO */
-	unsigned int uiGPIOValue;   /* 0 or 1; value to be set when command is 1. */
+	unsigned int uiGPIOMask; /* set the corresponding bit to 1 to access GPIO */
+	unsigned int uiGPIOValue; /* 0 or 1; value to be set when command is 1. */
 } __packed;
 
 struct bcm_gpio_multi_mode {
-	unsigned int uiGPIOMode;    /* 1 for OUT mode, 0 for IN mode */
-	unsigned int uiGPIOMask;    /* GPIO mask to set mode */
+	unsigned int uiGPIOMode; /* 1 for OUT mode, 0 for IN mode */
+	unsigned int uiGPIOMask; /* GPIO mask to set mode */
 } __packed;
 
 #endif
-- 
2.1.0

