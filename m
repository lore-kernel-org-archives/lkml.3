Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaCKKba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:31:30 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:43668 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaCKKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH trivial 11/16] ath10k: Improve grammar in comments
Date: Tue, 11 Mar 2014 11:23:45 +0100
Message-Id: <1394533430-4746-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath10k/wmi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4b5e7d3d32b6..8bce1113b753 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1265,7 +1265,7 @@ struct wmi_resource_config {
 	 */
 	__le32 rx_decap_mode;
 
-	/* what is the maximum scan requests than can be queued */
+	/* what is the maximum number of scan requests that can be queued */
 	__le32 scan_max_pending_reqs;
 
 	/* maximum VDEV that could use BMISS offload */
@@ -1450,7 +1450,7 @@ struct wmi_resource_config_10x {
 	 */
 	__le32 rx_decap_mode;
 
-	/* what is the maximum scan requests than can be queued */
+	/* what is the maximum number of scan requests that can be queued */
 	__le32 scan_max_pending_reqs;
 
 	/* maximum VDEV that could use BMISS offload */
-- 
1.7.9.5

