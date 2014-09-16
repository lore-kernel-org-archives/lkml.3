Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaIPUAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:00:45 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:33202 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaIPUAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:00:43 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Tomas Winkler <tomas.winkler@intel.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] mei: Spelling s/domian/domain/, s/stucture/structure/
Date: Tue, 16 Sep 2014 22:00:47 +0200
Message-Id: <1410897647-28308-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/misc/mei/pci-me.c  | 4 ++--
 drivers/misc/mei/pci-txe.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a0e9422b55a26aa9..959c313d84a73318 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -424,7 +424,7 @@ static int mei_me_pm_runtime_resume(struct device *device)
 }
 
 /**
- * mei_me_set_pm_domain - fill and set pm domian stucture for device
+ * mei_me_set_pm_domain - fill and set pm domain structure for device
  *
  * @dev: mei_device
  */
@@ -444,7 +444,7 @@ static inline void mei_me_set_pm_domain(struct mei_device *dev)
 }
 
 /**
- * mei_me_unset_pm_domain - clean pm domian stucture for device
+ * mei_me_unset_pm_domain - clean pm domain structure for device
  *
  * @dev: mei_device
  */
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index 19de57368b7a2e88..74727dda51c1ba97 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -371,7 +371,7 @@ static int mei_txe_pm_runtime_resume(struct device *device)
 }
 
 /**
- * mei_txe_set_pm_domain - fill and set pm domian stucture for device
+ * mei_txe_set_pm_domain - fill and set pm domain structure for device
  *
  * @dev: mei_device
  */
@@ -391,7 +391,7 @@ static inline void mei_txe_set_pm_domain(struct mei_device *dev)
 }
 
 /**
- * mei_txe_unset_pm_domain - clean pm domian stucture for device
+ * mei_txe_unset_pm_domain - clean pm domain structure for device
  *
  * @dev: mei_device
  */
-- 
1.9.1

