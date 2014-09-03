Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbaICWdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:33:53 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:65165 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbaICWdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:33:50 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org, gulsah.1004@gmail.com,
        paulmck@linux.vnet.ibm.com, Larry.Finger@lwfinger.net,
        linville@tuxdriver.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH] Staging: rtl8821ae: base: add missing blank line after declaration
Date: Wed,  3 Sep 2014 18:33:08 -0400
Message-Id: <1409783588-8814-1-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing blank line after declaration to fix coding style issue.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
index 4a36da0..dbf28ce 100644
--- a/drivers/staging/rtl8821ae/base.c
+++ b/drivers/staging/rtl8821ae/base.c
@@ -364,6 +364,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 		SET_IEEE80211_PERM_ADDR(hw, rtlefuse->dev_addr);
 	} else {
 		u8 rtlmac[] = { 0x00, 0xe0, 0x4c, 0x81, 0x92, 0x00 };
+
 		get_random_bytes((rtlmac + (ETH_ALEN - 1)), 1);
 		SET_IEEE80211_PERM_ADDR(hw, rtlmac);
 	}
@@ -553,6 +554,7 @@ static void _rtl_query_shortgi(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	u8 rate_flag = info->control.rates[0].flags;
 	u8 sgi_40 = 0, sgi_20 = 0, bw_40 = 0;
+
 	tcb_desc->use_shortgi = false;
 
 	if (sta == NULL)
-- 
2.1.0

