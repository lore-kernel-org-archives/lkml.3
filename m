Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbbALSVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:21:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbbALSGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 067/216] iwlwifi: mvm: update values for Smart Fifo
Date: Mon, 12 Jan 2015 18:03:04 +0000
Message-Id: <1421085933-32536-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b4c82adcba8cb4b23068a6b800ca98da3bee6888 upstream.

Interoperability issues were identified and root caused to
the Smart Fifo watermarks. These issues arose with
NetGear R7000. Fix this.

Fixes: 1f3b0ff8ecce ("iwlwifi: mvm: Add Smart FIFO support")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 41a181683a00..bafdf24dacaa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1466,7 +1466,7 @@ enum iwl_sf_scenario {
 #define SF_NUM_TIMEOUT_TYPES 2		/* Aging timer and Idle timer */
 
 /* smart FIFO default values */
-#define SF_W_MARK_SISO 4096
+#define SF_W_MARK_SISO 6144
 #define SF_W_MARK_MIMO2 8192
 #define SF_W_MARK_MIMO3 6144
 #define SF_W_MARK_LEGACY 4096
-- 
2.1.4

