Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaKDMtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:49:22 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65314 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaKDMtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:49:19 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: lisovy@gmail.com, fengguang.wu@intel.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH] cfg80211: Move join/leave_ocb comments to be in the correct order
Date: Tue,  4 Nov 2014 13:49:12 +0100
Message-Id: <1415105352-4295-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the same ordering in the comments section as it
is in the structure below.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c3acd0..af0ef26 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2182,6 +2182,11 @@ struct cfg80211_qos_map {
  * @leave_mesh: leave the current mesh network
  *	(invoked with the wireless_dev mutex held)
  *
+ * @join_ocb: join the OCB network with the specified parameters
+ *	(invoked with the wireless_dev mutex held)
+ * @leave_ocb: leave the current OCB network
+ *	(invoked with the wireless_dev mutex held)
+ *
  * @get_mesh_config: Get the current mesh configuration
  *
  * @update_mesh_config: Update mesh parameters on a running mesh.
@@ -2362,11 +2367,6 @@ struct cfg80211_qos_map {
  *	with the peer followed by immediate teardown when the addition is later
  *	rejected)
  * @del_tx_ts: remove an existing TX TS
- *
- * @join_ocb: join the OCB network with the specified parameters
- *	(invoked with the wireless_dev mutex held)
- * @leave_ocb: leave the current OCB network
- *	(invoked with the wireless_dev mutex held)
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
-- 
2.0.0.rc4

