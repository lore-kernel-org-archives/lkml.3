Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3FRJuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:50:40 -0400
Received: from multi.imgtec.com ([194.200.65.239]:4600 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab3FRJuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:50:39 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] pinctrl: fix pinconf_ops::pin_config_dbg_parse_modify kerneldoc
Date: Tue, 18 Jun 2013 10:49:33 +0100
Message-ID: <1371548973-7197-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_18_10_50_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kerneldoc comment for struct pinconf_ops was missing
pin_config_dbg_parse_modify, and instead described
pin_config_group_dbg_set (which is presumably an old name for the same
function). Rename it in the kerneldoc comment so they match.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/pinconf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index 1ad4f31..f699869 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -30,7 +30,7 @@ struct seq_file;
  * @pin_config_set: configure an individual pin
  * @pin_config_group_get: get configurations for an entire pin group
  * @pin_config_group_set: configure all pins in a group
- * @pin_config_group_dbg_set: optional debugfs to modify a pin configuration
+ * @pin_config_dbg_parse_modify: optional debugfs to modify a pin configuration
  * @pin_config_dbg_show: optional debugfs display hook that will provide
  *	per-device info for a certain pin in debugfs
  * @pin_config_group_dbg_show: optional debugfs display hook that will provide
-- 
1.8.1.2


