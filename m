Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaHJOql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:46:41 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51237 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaHJOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:46:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/22] staging: rtl8188eu: Hal8188EPhyCfg.h: Remove unused function declaration
Date: Sun, 10 Aug 2014 20:14:23 +0530
Message-Id: <1407681875-2611-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 49e1825..161ad76 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -206,17 +206,6 @@ u32 rtl8188e_PHY_QueryRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
 void rtl8188e_PHY_SetRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
 			   u32 regaddr, u32 mask, u32 data);
 
-/*  Initialization related function */
-/* MAC/BB/RF HAL config */
-int PHY_BBConfig8188E(struct adapter *adapter);
-int PHY_RFConfig8188E(struct adapter *adapter);
-
-/* RF config */
-int rtl8188e_PHY_ConfigRFWithParaFile(struct adapter *adapter, u8 *filename,
-				      enum rf_radio_path rfpath);
-int rtl8188e_PHY_ConfigRFWithHeaderFile(struct adapter *adapter,
-					enum rf_radio_path rfpath);
-
 /* Read initi reg value for tx power setting. */
 void rtl8192c_PHY_GetHWRegOriginalValue(struct adapter *adapter);
 
-- 
1.7.10.4

