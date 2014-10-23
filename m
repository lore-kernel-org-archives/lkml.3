Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaJWJxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:53:14 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:48505 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaJWJw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:52:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH/TRIVIAL 3/4] iwlegacy: 4965-rs: Remove bogus colon after newline from debug message
Date: Thu, 23 Oct 2014 11:52:56 +0200
Message-Id: <1414057977-4191-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
References: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index eaaeea19d8c5bcc9..bac60b2bc3f014a5 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -1678,7 +1678,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 		    lq_sta->total_success > lq_sta->max_success_limit ||
 		    (!lq_sta->search_better_tbl && lq_sta->flush_timer &&
 		     flush_interval_passed)) {
-			D_RATE("LQ: stay is expired %d %d %d\n:",
+			D_RATE("LQ: stay is expired %d %d %d\n",
 			       lq_sta->total_failed, lq_sta->total_success,
 			       flush_interval_passed);
 
-- 
1.9.1

