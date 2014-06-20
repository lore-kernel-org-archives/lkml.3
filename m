Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaFTPBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:30 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33621 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaFTPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:27 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/41] staging: rtl8188eu: rtw_efuse.c: Remove unnecessary function declaration
Date: Fri, 20 Jun 2014 20:29:17 +0530
Message-Id: <1403276387-11841-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 7752efd..bae0fca 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -47,16 +47,10 @@ u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN] = {0};
 #define EFUSE_CTRL			REG_EFUSE_CTRL		/*  E-Fuse Control. */
 /*  */
 
-bool
-Efuse_Read1ByteFromFakeContent(
+static bool Efuse_Read1ByteFromFakeContent(
 			struct adapter *pAdapter,
 			u16 Offset,
-		u8 *Value);
-bool
-Efuse_Read1ByteFromFakeContent(
-			struct adapter *pAdapter,
-			u16 Offset,
-		u8 *Value)
+			u8 *Value)
 {
 	if (Offset >= EFUSE_MAX_HW_SIZE)
 		return false;
-- 
1.7.10.4

