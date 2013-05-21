Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EUOOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:14:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab3EUOOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:14:19 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Correct spelling mistake in comment
Date: Tue, 21 May 2013 15:04:07 +0100
Message-Id: <1369145047-26748-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e3661c2..0218a93 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2535,7 +2535,7 @@ EXPORT_SYMBOL_GPL(regulator_get_voltage);
 /**
  * regulator_set_current_limit - set regulator output current limit
  * @regulator: regulator source
- * @min_uA: Minimuum supported current in uA
+ * @min_uA: Minimum supported current in uA
  * @max_uA: Maximum supported current in uA
  *
  * Sets current sink to the desired output current. This can be set during
-- 
1.7.2.5

