Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaB0QHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:07:36 -0500
Received: from mout.gmx.net ([212.227.17.21]:58021 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbaB0QH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:07:29 -0500
From: xypron.glpk@gmx.de
To: Larry.Finger@lwfinger.net
Cc: chaoming_li@realsil.com.cn, linville@tuxdriver.com, felipensp@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH] Remove redundant if clause
Date: Thu, 27 Feb 2014 17:06:58 +0100
Message-Id: <1393517218-11043-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:6nDaWjRFxuOl+Wc3E0Z3eNPnlq3f31pBQlj9wUker01ei1uYp6i
 iMn4p1nSdQy84u5xq8E6iTlLXt9uYf5k7usxNNSdZOb01XbHcjCZi9qe0ke76a+YP5KL+f0
 RJDoqNR0b8YDEBDEOtp87YWL7nuDY7h4tzlN24QZJGAWHRf40YX8w5OAwZmfxY4Eanfmzhc
 esXBLO3Q+h5fkvKxT7UIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 92d38ab..78a81c1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -52,7 +52,7 @@ static void _rtl92s_get_powerbase(struct ieee80211_hw *hw, u8 *p_pwrlevel,
 	/* We only care about the path A for legacy. */
 	if (rtlefuse->eeprom_version < 2) {
 		pwrbase0 = pwrlevel[0] + (rtlefuse->legacy_httxpowerdiff & 0xf);
-	} else if (rtlefuse->eeprom_version >= 2) {
+	} else {
 		legacy_pwrdiff = rtlefuse->txpwr_legacyhtdiff
 						[RF90_PATH_A][chnl - 1];
 
-- 
1.7.10.4

