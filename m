Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaHJOsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:48:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53364 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHJOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/22] staging: rtl8188eu: rtw_iol.h: Remove unused struct, enum and macro
Date: Sun, 10 Aug 2014 20:14:34 +0530
Message-Id: <1407681875-2611-21-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_iol.h |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index 8ebdddb..68aae7f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -23,29 +23,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-#define IOREG_CMD_END_LEN	4
-
-struct ioreg_cfg {
-	u8	length;
-	u8	cmd_id;
-	__le16	address;
-	__le32	data;
-	__le32  mask;
-};
-
-enum ioreg_cmd {
-	IOREG_CMD_LLT		= 0x01,
-	IOREG_CMD_REFUSE	= 0x02,
-	IOREG_CMD_EFUSE_PATH	= 0x03,
-	IOREG_CMD_WB_REG	= 0x04,
-	IOREG_CMD_WW_REG	= 0x05,
-	IOREG_CMD_WD_REG	= 0x06,
-	IOREG_CMD_W_RF		= 0x07,
-	IOREG_CMD_DELAY_US	= 0x10,
-	IOREG_CMD_DELAY_MS	= 0x11,
-	IOREG_CMD_END		= 0xFF,
-};
-
 bool rtw_IOL_applied(struct adapter  *adapter);
 
 #endif /* __RTW_IOL_H_ */
-- 
1.7.10.4

