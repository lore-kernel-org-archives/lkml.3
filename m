Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbaLBTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:25:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaLBTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 100/121] ath9k: Add version/revision macros for QCA9531
Date: Tue,  2 Dec 2014 11:19:39 -0800
Message-Id: <1417548000-1794-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit f5ee2b18e44d8752ea6e6fba978a873ed5f562bd upstream.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a13b2d1..c148f33 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -810,6 +810,9 @@
 #define AR_SREV_VERSION_9565            0x2C0
 #define AR_SREV_REVISION_9565_10        0
 #define AR_SREV_VERSION_9550		0x400
+#define AR_SREV_VERSION_9531            0x500
+#define AR_SREV_REVISION_9531_10        0
+#define AR_SREV_REVISION_9531_11        1
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -938,11 +941,19 @@
 #define AR_SREV_9580(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
 	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9580_10))
-
 #define AR_SREV_9580_10(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
 	((_ah)->hw_version.macRev == AR_SREV_REVISION_9580_10))
 
+#define AR_SREV_9531(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531))
+#define AR_SREV_9531_10(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_10))
+#define AR_SREV_9531_11(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_11))
+
 /* NOTE: When adding chips newer than Peacock, add chip check here */
 #define AR_SREV_9580_10_OR_LATER(_ah) \
 	(AR_SREV_9580(_ah))
-- 
1.9.1

