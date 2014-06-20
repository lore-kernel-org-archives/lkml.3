Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaFTPFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:05:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62835 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaFTPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:05:03 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 39/41] staging: rtl8188eu: rtw_efuse.c: Remove unused local variables
Date: Fri, 20 Jun 2014 20:29:45 +0530
Message-Id: <1403276387-11841-40-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index a0204ed..26d1d51 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -24,24 +24,6 @@
 #include <rtw_efuse.h>
 #include <usb_ops_linux.h>
 
-/*------------------------Define local variable------------------------------*/
-u8 fakeEfuseBank;
-u32 fakeEfuseUsedBytes;
-u8 fakeEfuseContent[EFUSE_MAX_HW_SIZE] = {0};
-u8 fakeEfuseInitMap[EFUSE_MAX_MAP_LEN] = {0};
-u8 fakeEfuseModifiedMap[EFUSE_MAX_MAP_LEN] = {0};
-
-u32 BTEfuseUsedBytes;
-u8 BTEfuseContent[EFUSE_MAX_BT_BANK][EFUSE_MAX_HW_SIZE];
-u8 BTEfuseInitMap[EFUSE_BT_MAX_MAP_LEN] = {0};
-u8 BTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN] = {0};
-
-u32 fakeBTEfuseUsedBytes;
-u8 fakeBTEfuseContent[EFUSE_MAX_BT_BANK][EFUSE_MAX_HW_SIZE];
-u8 fakeBTEfuseInitMap[EFUSE_BT_MAX_MAP_LEN] = {0};
-u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN] = {0};
-/*------------------------Define local variable------------------------------*/
-
 /*  */
 #define REG_EFUSE_CTRL		0x0030
 #define EFUSE_CTRL			REG_EFUSE_CTRL		/*  E-Fuse Control. */
-- 
1.7.10.4

