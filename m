Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaIBAb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:31:27 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:52690 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaIBAa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:57 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 11/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:35 -0400
Message-Id: <1409617776-30730-11-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue which requires a space after the equal sign '='.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index 38addec..d587072 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -347,7 +347,7 @@ void rtl8821ae_dm_bt_balance(struct ieee80211_hw *hw,
 {
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 h2c_parameter[3] ={0};
+	u8 h2c_parameter[3] = {0};
 
 	if (b_balance_on) {
 		h2c_parameter[2] = 1;
-- 
2.1.0

