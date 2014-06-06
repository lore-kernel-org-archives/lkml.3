Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaFFQQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:35 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60217 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaFFQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/13] staging: rtl8188eu: rtw_io.h: Remove unused structures
Date: Fri,  6 Jun 2014 21:45:17 +0530
Message-Id: <1402071320-14400-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_io.h |   85 ----------------------------
 1 file changed, 85 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index e30b84b..e56c52b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -142,91 +142,6 @@ struct	intf_hdl {
 	struct _io_ops	io_ops;
 };
 
-struct reg_protocol_rd {
-#ifdef __LITTLE_ENDIAN
-	/* DW1 */
-	u32		NumOfTrans:4;
-	u32		Reserved1:4;
-	u32		Reserved2:24;
-	/* DW2 */
-	u32		ByteCount:7;
-	u32		WriteEnable:1;		/* 0:read, 1:write */
-	u32		FixOrContinuous:1;	/* 0:continuous, 1: Fix */
-	u32		BurstMode:1;
-	u32		Byte1Access:1;
-	u32		Byte2Access:1;
-	u32		Byte4Access:1;
-	u32		Reserved3:3;
-	u32		Reserved4:16;
-	/* DW3 */
-	u32		BusAddress;
-	/* DW4 */
-	/* u32		Value; */
-#else
-/* DW1 */
-	u32 Reserved1:4;
-	u32 NumOfTrans:4;
-	u32 Reserved2:24;
-	/* DW2 */
-	u32 WriteEnable:1;
-	u32 ByteCount:7;
-	u32 Reserved3:3;
-	u32 Byte4Access:1;
-
-	u32 Byte2Access:1;
-	u32 Byte1Access:1;
-	u32 BurstMode:1;
-	u32 FixOrContinuous:1;
-	u32 Reserved4:16;
-	/* DW3 */
-	u32	BusAddress;
-
-	/* DW4 */
-#endif
-};
-
-struct reg_protocol_wt {
-#ifdef __LITTLE_ENDIAN
-	/* DW1 */
-	u32	NumOfTrans:4;
-	u32	Reserved1:4;
-	u32	Reserved2:24;
-	/* DW2 */
-	u32	ByteCount:7;
-	u32	WriteEnable:1;		/* 0:read, 1:write */
-	u32	FixOrContinuous:1;	/* 0:continuous, 1: Fix */
-	u32	BurstMode:1;
-	u32	Byte1Access:1;
-	u32	Byte2Access:1;
-	u32	Byte4Access:1;
-	u32	Reserved3:3;
-	u32	Reserved4:16;
-	/* DW3 */
-	u32	BusAddress;
-	/* DW4 */
-	u32	Value;
-#else
-	/* DW1 */
-	u32 Reserved1:4;
-	u32 NumOfTrans:4;
-	u32 Reserved2:24;
-	/* DW2 */
-	u32 WriteEnable:1;
-	u32 ByteCount:7;
-	u32 Reserved3:3;
-	u32 Byte4Access:1;
-	u32 Byte2Access:1;
-	u32 Byte1Access:1;
-	u32 BurstMode:1;
-	u32 FixOrContinuous:1;
-	u32 Reserved4:16;
-	/* DW3 */
-	u32	BusAddress;
-	/* DW4 */
-	u32	Value;
-#endif
-};
-
 /*
 Below is the data structure used by _io_handler
 */
-- 
1.7.10.4

