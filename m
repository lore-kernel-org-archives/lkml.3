Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaF1NR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:17:29 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:63310 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaF1NR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:17:28 -0400
From: "Morgan S. Stuart" <morgansstuartdev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, linville@tuxdriver.com, iacobcatalin@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Morgan S. Stuart" <morgansstuartdev@gmail.com>
Subject: [PATCH] Staging: rtl8192ee: fixed tab coding style issue in base.h
Date: Sat, 28 Jun 2014 09:16:52 -0400
Message-Id: <1403961412-5515-1-git-send-email-morgansstuartdev@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the tab error found in base.h, reported by checkpatch.pl tool

Signed-off-by: Morgan Stuart <morgansstuartdev@gmail.com>
---
 drivers/staging/rtl8192ee/base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192ee/base.h b/drivers/staging/rtl8192ee/base.h
index c7929a7..1d6e5a7 100644
--- a/drivers/staging/rtl8192ee/base.h
+++ b/drivers/staging/rtl8192ee/base.h
@@ -132,13 +132,13 @@ u8 rtl92e_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb,
 void rtl92e_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
 void rtl92e_watch_dog_timer_callback(unsigned long data);
 int rtl92e_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		        struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int rtl92e_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
 int rtl92e_tx_agg_oper(struct ieee80211_hw *hw,
 		       struct ieee80211_sta *sta, u16 tid);
 int rtl92e_rx_agg_start(struct ieee80211_hw *hw,
-		        struct ieee80211_sta *sta, u16 tid);
+			struct ieee80211_sta *sta, u16 tid);
 int rtl92e_rx_agg_stop(struct ieee80211_hw *hw,
 		       struct ieee80211_sta *sta, u16 tid);
 void rtl92e_watchdog_wq_callback(void *data);
-- 
1.9.3

