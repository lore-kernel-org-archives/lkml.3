Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaGTOVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:21:09 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:38275 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbaGTOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:21:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAO7Py1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDSQcBeFe4lQBxaEMAWbJZQvg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 07/30] rtlwifi: rtl8192se: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:15 +0200
Message-Id: <1405865801-18806-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c | 3 ---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
index 380e7d4..b15aa5c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -112,13 +112,10 @@ static u8 _rtl92s_firmware_header_map_rftype(struct ieee80211_hw *hw)
 	switch (rtlphy->rf_type) {
 	case RF_1T1R:
 		return 0x11;
-		break;
 	case RF_1T2R:
 		return 0x12;
-		break;
 	case RF_2T2R:
 		return 0x22;
-		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown RF type(%x)\n",
 			 rtlphy->rf_type);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 1c7101b..00e0670 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1198,7 +1198,6 @@ static int _rtl92se_set_media_status(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Network type %d not supported!\n", type);
 		return 1;
-		break;
 
 	}
 
-- 
1.9.1

