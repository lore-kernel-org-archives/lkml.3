Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3JTGpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 02:45:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33624 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916Ab3JTGph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 02:45:37 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: johannes@sipsolutions.net, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mac80211: document IEEE80211_HW_SUPPORTS_HT_CCK_RATES
Date: Sun, 20 Oct 2013 08:45:29 +0200
Message-Id: <1382251529-22540-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the IEEE80211_HW_SUPPORTS_HT_CCK_RATES flag
in ieee80211_hw_flags.

Without this, you get countless warnings in "make htmldocs".

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 include/net/mac80211.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cc6035f..0a26a6e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1492,6 +1492,9 @@ struct ieee80211_tx_control {
  *
  * @IEEE80211_HW_TIMING_BEACON_ONLY: Use sync timing from beacon frames
  *	only, to allow getting TBTT of a DTIM beacon.
+ *
+ * @IEEE80211_HW_SUPPORTS_HT_CCK_RATES:
+ *	Hardware has CCK support for HT clients.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
-- 
1.8.1.2

