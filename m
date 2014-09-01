Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaIAPoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:44:09 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55181 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaIAPoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:44:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 2/8] staging: rtl8188eu: Hal8188EPwrSeq.c: fix lines over 80 characters.
Date: Mon,  1 Sep 2014 21:13:37 +0530
Message-Id: <1409586223-5915-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
References: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c |   46 ++++++++++++++++--------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c b/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
index fc23bf1..4c29e63 100644
--- a/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
+++ b/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
@@ -25,61 +25,77 @@
     drivers should parse below arrays and do the corresponding actions
 */
 /* 3 Power on  Array */
-struct wl_pwr_cfg rtl8188E_power_on_flow[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_power_on_flow[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS +
+					 RTL8188E_TRANS_END_STEPS] = {
 	RTL8188E_TRANS_CARDEMU_TO_ACT
 	RTL8188E_TRANS_END
 };
 
 /* 3Radio off Array */
-struct wl_pwr_cfg rtl8188E_radio_off_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_radio_off_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+					  RTL8188E_TRANS_END_STEPS] = {
 	RTL8188E_TRANS_ACT_TO_CARDEMU
 	RTL8188E_TRANS_END
 };
 
 /* 3Card Disable Array */
-struct wl_pwr_cfg rtl8188E_card_disable_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS + RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_ACT_TO_CARDEMU
-	RTL8188E_TRANS_CARDEMU_TO_CARDDIS
-	RTL8188E_TRANS_END
+struct wl_pwr_cfg rtl8188E_card_disable_flow
+	[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+	 RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+	 RTL8188E_TRANS_END_STEPS] = {
+		RTL8188E_TRANS_ACT_TO_CARDEMU
+		RTL8188E_TRANS_CARDEMU_TO_CARDDIS
+		RTL8188E_TRANS_END
 };
 
 /* 3 Card Enable Array */
-struct wl_pwr_cfg rtl8188E_card_enable_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS + RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_CARDDIS_TO_CARDEMU
-	RTL8188E_TRANS_CARDEMU_TO_ACT
-	RTL8188E_TRANS_END
+struct wl_pwr_cfg rtl8188E_card_enable_flow
+	[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+	 RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+	 RTL8188E_TRANS_END_STEPS] = {
+		RTL8188E_TRANS_CARDDIS_TO_CARDEMU
+		RTL8188E_TRANS_CARDEMU_TO_ACT
+		RTL8188E_TRANS_END
 };
 
 /* 3Suspend Array */
-struct wl_pwr_cfg rtl8188E_suspend_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_suspend_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+					RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
+					RTL8188E_TRANS_END_STEPS] = {
 	RTL8188E_TRANS_ACT_TO_CARDEMU
 	RTL8188E_TRANS_CARDEMU_TO_SUS
 	RTL8188E_TRANS_END
 };
 
 /* 3 Resume Array */
-struct wl_pwr_cfg rtl8188E_resume_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_resume_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+				       RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
+				       RTL8188E_TRANS_END_STEPS] = {
 	RTL8188E_TRANS_SUS_TO_CARDEMU
 	RTL8188E_TRANS_CARDEMU_TO_ACT
 	RTL8188E_TRANS_END
 };
 
 /* 3HWPDN Array */
-struct wl_pwr_cfg rtl8188E_hwpdn_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_hwpdn_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+				      RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+				      RTL8188E_TRANS_END_STEPS] = {
 	RTL8188E_TRANS_ACT_TO_CARDEMU
 	RTL8188E_TRANS_CARDEMU_TO_PDN
 	RTL8188E_TRANS_END
 };
 
 /* 3 Enter LPS */
-struct wl_pwr_cfg rtl8188E_enter_lps_flow[RTL8188E_TRANS_ACT_TO_LPS_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_enter_lps_flow[RTL8188E_TRANS_ACT_TO_LPS_STEPS +
+					  RTL8188E_TRANS_END_STEPS] = {
 	/* FW behavior */
 	RTL8188E_TRANS_ACT_TO_LPS
 	RTL8188E_TRANS_END
 };
 
 /* 3 Leave LPS */
-struct wl_pwr_cfg rtl8188E_leave_lps_flow[RTL8188E_TRANS_LPS_TO_ACT_STEPS + RTL8188E_TRANS_END_STEPS] = {
+struct wl_pwr_cfg rtl8188E_leave_lps_flow[RTL8188E_TRANS_LPS_TO_ACT_STEPS +
+					  RTL8188E_TRANS_END_STEPS] = {
 	/* FW behavior */
 	RTL8188E_TRANS_LPS_TO_ACT
 	RTL8188E_TRANS_END
-- 
1.7.10.4

