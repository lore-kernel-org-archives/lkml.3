Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911AbaGBQzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:55:19 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38830 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbaGBQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:55:14 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 46/48] staging: rtl8188eu: rtw_cmd.h: Remove unused structures
Date: Wed,  2 Jul 2014 22:17:42 +0530
Message-Id: <1404319664-8327-46-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 7dfbd8b..bad84b2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -319,22 +319,6 @@ struct SetChannelPlan_param {
 	u8 channel_plan;
 };
 
-/*H2C Handler index: 60 */
-struct LedBlink_param {
-	struct LED_871x *pLed;
-};
-
-/*H2C Handler index: 61 */
-struct SetChannelSwitch_param {
-	u8 new_ch_no;
-};
-
-/*H2C Handler index: 62 */
-struct TDLSoption_param {
-	u8 addr[ETH_ALEN];
-	u8 option;
-};
-
 #define GEN_CMD_CODE(cmd)	cmd ## _CMD_
 
 /*
-- 
1.7.10.4

