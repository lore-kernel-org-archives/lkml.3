Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaFTPFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:05:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36422 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965627AbaFTPE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 38/41] staging: rtl8188eu: rtw_efuse.c: Remove unused global variables
Date: Fri, 20 Jun 2014 20:29:44 +0530
Message-Id: <1403276387-11841-39-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_efuse.h |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 00f8797..b608b92 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -99,24 +99,6 @@ struct efuse_hal {
 	u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN];
 };
 
-/*------------------------Export global variable----------------------------*/
-extern u8 fakeEfuseBank;
-extern u32 fakeEfuseUsedBytes;
-extern u8 fakeEfuseContent[];
-extern u8 fakeEfuseInitMap[];
-extern u8 fakeEfuseModifiedMap[];
-
-extern u32 BTEfuseUsedBytes;
-extern u8 BTEfuseContent[EFUSE_MAX_BT_BANK][EFUSE_MAX_HW_SIZE];
-extern u8 BTEfuseInitMap[];
-extern u8 BTEfuseModifiedMap[];
-
-extern u32 fakeBTEfuseUsedBytes;
-extern u8 fakeBTEfuseContent[EFUSE_MAX_BT_BANK][EFUSE_MAX_HW_SIZE];
-extern u8 fakeBTEfuseInitMap[];
-extern u8 fakeBTEfuseModifiedMap[];
-/*------------------------Export global variable----------------------------*/
-
 u8 efuse_GetCurrentSize(struct adapter *adapter, u16 *size);
 u16 efuse_GetMaxSize(struct adapter *adapter);
 u8 rtw_efuse_access(struct adapter *adapter, u8 read, u16 start_addr,
-- 
1.7.10.4

