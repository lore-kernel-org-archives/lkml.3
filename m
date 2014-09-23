Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaIWXJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:09:54 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:54085 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbaIWXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:09:52 -0400
Message-ID: <5421FDBE.1080706@gmail.com>
Date: Tue, 23 Sep 2014 19:09:50 -0400
From: Jerry Stralko <gerb.stralko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: gulsah.1004@gmail.com, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, gerb.stralko@gmail.com
Subject: [PATCH] stagging : rtl8821ae : Fixed sparse warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symbol was not declared. Should it be static?

Signed-off-by: Jerry Stralko 
---
 drivers/staging/rtl8821ae/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
index 4a36da0..dea3c4b 100644
--- a/drivers/staging/rtl8821ae/base.c
+++ b/drivers/staging/rtl8821ae/base.c
@@ -1367,7 +1367,7 @@ u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
 
 /* when we use 2 rx ants we send IEEE80211_SMPS_OFF */
 /* when we use 1 rx ant we send IEEE80211_SMPS_STATIC */
-struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
+static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
 				     enum ieee80211_smps_mode smps,
 				     u8 *da, u8 *bssid)
 {
@@ -1540,7 +1540,7 @@ static bool rtl_chk_vendor_ouisub(struct ieee80211_hw *hw,
 	return matched;
 }
 
-bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
+static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
 		unsigned int len)
 {
 	struct ieee80211_mgmt *mgmt = (void *)data;
-- 
1.9.3

