Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaDDIiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:38:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60576 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbaDDIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:38:13 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: core: Fix typo in of_regulator.h
Date: Fri,  4 Apr 2014 09:29:58 +0100
Message-Id: <1396600198-7288-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo from my patch adding of_regulator_put_match in the patch:

regulator: core: Add helper to put of_nodes from matches

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 include/linux/regulator/of_regulator.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index 0652851..a5abd83 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -38,7 +38,7 @@ static inline int of_regulator_match(struct device *dev,
 	return 0;
 }
 static inline int of_regulator_put_match(struct of_regulator_match *matches,
-					 unsigned int num_matches);
+					 unsigned int num_matches)
 {
 	return 0;
 }
-- 
1.7.2.5

