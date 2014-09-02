Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIBAbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:31:01 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55042 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaIBAa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:58 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 12/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:36 -0400
Message-Id: <1409617776-30730-12-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue which requires a blank line after declarations.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index d587072..293bf9d 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -435,6 +435,7 @@ void rtl8821ae_dm_bt_fw_coex_all_off(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 		("rtl8821ae_dm_bt_fw_coex_all_off()\n"));
 
-- 
2.1.0

