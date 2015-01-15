Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbbAOKF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:05:27 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58024 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbAOKFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:05:24 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] mac80211: Fix typo in mac80211.h
Date: Thu, 15 Jan 2015 19:05:22 +0900
Message-Id: <1421316322-16879-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo found in Documentation/DocBook/80211.xml.
It is because this file was generated from comments in source,
I had to fix in include/net/mac80211.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 include/net/mac80211.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 29c7be8..a9a6213 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1292,7 +1292,7 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
  * @IEEE80211_KEY_FLAG_GENERATE_IV_MGMT: This flag should be set by the
  *	driver for a CCMP key to indicate that is requires IV generation
- *	only for managment frames (MFP).
+ *	only for management frames (MFP).
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -4894,7 +4894,7 @@ static inline int rate_supported(struct ieee80211_sta *sta,
  * @sta: &struct ieee80211_sta pointer to the target destination. Note
  * 	that this may be null.
  * @priv_sta: private rate control structure. This may be null.
- * @txrc: rate control information we sholud populate for mac80211.
+ * @txrc: rate control information we should populate for mac80211.
  */
 bool rate_control_send_low(struct ieee80211_sta *sta,
 			   void *priv_sta,
-- 
2.3.0.rc0

