Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701Ab3DBFvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:51:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47375 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070Ab3DBFvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:51:02 -0400
From: "Edward O'Callaghan" <victoredwardocallaghan@gmail.com>
To: ath9k-devel@venema.h4ckr.net
Cc: linux-kernel@vger.kernel.org,
        "Edward O'Callaghan" <victoredwardocallaghan@gmail.com>
Subject: [PATCH] Trivial fix for ath9k dmesg typo.
Date: Tue,  2 Apr 2013 16:50:51 +1100
Message-Id: <1364881851-21872-1-git-send-email-victoredwardocallaghan@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Edward O'Callaghan <victoredwardocallaghan@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 07e2526..76da544 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -778,7 +778,7 @@ u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 		udelay(100);
 
 		if (WARN_ON_ONCE(i >= 100)) {
-			ath_err(common, "PLL4 meaurement not done\n");
+			ath_err(common, "PLL4 measurement not done\n");
 			break;
 		}
 
-- 
1.8.2

